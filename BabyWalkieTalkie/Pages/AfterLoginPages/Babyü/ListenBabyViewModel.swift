//
//  ListenBabyViewControl.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 12.08.2021.
//
import Foundation
import Combine

final class ListenBabyViewModel:ListenBabyViewModelProtocol{
    weak var delegate: ListenBabyViewModelDelegate?
    var router:ListenBabyRouter!
    var firebaseService: FirebaseAgoraService!
    var agoraService: AgoraAudioService!
    var agoraMessageService: AgoraMessageService!
    var videoService: AgoraVideoService!
    var smartListenerProtocol:SmartListenerProtocol!
    var tokenDelegate: TokenServiceProtocol?
    var notification:NotificationCenter!
    let userName = "baby"
    var token: String!
    var rtmToken:String!
    var channelID: String!
    var soundLevel:Float = -30
    var messageTimer:Timer?
    var resetTimer:Timer?
    var stopTimer:Timer?
    var isSoundGoOn:Bool = false
    var isParentDeviceOnline:Bool = false
    var timeLogic = CurrentValueSubject<Bool,Never>(true)
    var subscriber:Set<AnyCancellable> = []
    var source:ConnectionSource?{
        didSet{
            switch source {
            case .video:
                stopAudio()
                startVideo()
            case .audio:
                startAudio()
                stopVideo()
            default:
                break
            }
        }
    }
    
    init() {
        notification = NotificationCenter
            .default
        timeLogic.sink { [unowned self] bool in
            if bool == false{
                messageTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(timerFunction), userInfo: nil, repeats: false)
            }
        }.store(in: &subscriber)
    }
    
    @objc func timerFunction(){
        timeLogic.send(true)
    }
    @objc func startSmartAgain(){
        smartListenerProtocol?.startToListen()
    }
    deinit {
        printNew("listen baby view model deinit")
    }
    //user press button
    //first check isthere anybody in channel
    // then return mutual channel id
    // then create token
    // create service
    // listen to medium
    // than send
    //MARK: - Audio 
    func startAudio() {
        //add observer notification
        notification.addObserver(self, selector: #selector(startSmartAgain), name: .notificationStartSmartListener, object: nil)
        //set baby to channel or if already have one in channel protect user enter channel as a baby role
        firebaseService.decideAboutChannel(){ [unowned self]result in
            switch result{
            case .success(let response):
                guard let response = response else {
                    delegate?.handleOutputs(.anyErrorOccurred("Unknown error.Please restart application"))
                    delegate?.handleOutputs(.isLoading(false))
                    return
                }
                if response == "notConnected"{
                    delegate?.handleOutputs(.isLoading(false))
                    delegate?.handleOutputs(.mustBeConnected)
                    return
                } else if response != "baby"{
                    firebaseService.enterTheChannel(role: .baby)
                    goOnAudioStartingSequence()
                } else{
                    delegate?.handleOutputs(.alreadyLogisAsBaby)
                    delegate?.handleOutputs(.isLoading(false))
                    return
                }
            case.failure:
                delegate?.handleOutputs(.isLoading(false))
                delegate?.handleOutputs(.anyErrorOccurred("Unknown error.Please restart application"))
                return
            }
        }
    }
    private func goOnAudioStartingSequence(){
        // start listen to medium
        smartListenerProtocol?.startToListen()
        // change status as connected
        delegate?.handleOutputs(.connected)
        //fetch channel informations and start broadcast
        firebaseService.fetchChannelID(){[unowned self] result in
            switch result{
            case .failure(let error):
                delegate?.handleOutputs(.isLoading(false))
                delegate?.handleOutputs(.anyErrorOccurred(error.localizedDescription))
            case .success(let channelID):
                guard let channelID = channelID else {return}
                self.channelID = channelID
                startBroadcast(channelID)
            }
        }
    }
    func stopAudio(){
        agoraService?.stopBroadcast()
        smartListenerProtocol.stopToListen()
        smartListenerProtocol.deleteAllTimer()
        deleteAllTimer()
    }
    func startBroadcast(_ channel:String) {
        // get rtc token according to channel
        tokenDelegate?.fetchRtcToken( channel: channel) {[unowned self] tokenResult in
            switch tokenResult{
            case.failure(let error):
                delegate?.handleOutputs(.isLoading(false))
                delegate?.handleOutputs(.anyErrorOccurred(error.localizedDescription))
            case .success(let _token):
                guard let _token = _token else {return}
                token = _token
                // get rtm token according to channel
                tokenDelegate?.fetchRtmToken(userName:userName){ rtmTokenResult in
                    switch rtmTokenResult{
                    case.failure(let error):
                        delegate?.handleOutputs(.isLoading(false))
                        delegate?.handleOutputs(.anyErrorOccurred(error.localizedDescription))
                    case .success(let _rtmToken):
                        guard let _rtmToken = _rtmToken else {return}
                        rtmToken = _rtmToken
                        agoraService = AgoraAudioService( token: token, channel: channel, username: "baby", role: .broadcaster)
                        agoraMessageService = AgoraMessageService(rtmToken: rtmToken, channel: channel, username: "baby")
                        agoraMessageService.delegate = self
                        delegate?.handleOutputs(.isLoading(false))
                    }
                }
            }
        }
    }
    
    func returnToSelectPage() {
        stopAudio()
        stopVideo()
        subscriber.removeAll()
        messageTimer?.invalidate()
        smartListenerProtocol = nil
        tokenDelegate = nil
        firebaseService = nil
        agoraService = nil
        agoraMessageService = nil
        router.routeTo(.toSelectPage)
    }
    func closePressed() {
        firebaseService.exitTheChannel(role: .baby) { _ in}
        returnToSelectPage()
    }
    func setPrecision(_ soundTreshold: Float) {
        soundLevel = soundTreshold
    }
    func deleteAllTimer(){
        stopTimer?.invalidate()
        resetTimer?.invalidate()
    }
    func startVideo() {
        defer{
            videoService.connectAgoraVideo()
        }
        videoService = AgoraVideoService(token: token, channel: channelID, username: "baby", role: .broadcaster)
    }
    func stopVideo() {
        videoService = nil
    }
    func otherDeviceDidUnpair() {
        let matchService = FirebaseMatchService()
        matchService.disconnetUsers { [unowned self] results in
            switch results{
            case.success:
                delegate?.handleOutputs(.otherDeviceDidUnpair)
            default:
                delegate?.handleOutputs(.anyErrorOccurred("Other user disconnected"))
            }
        }
    }
}
extension ListenBabyViewModel:SmartListenerDelegate{
    func setSoundLevel() -> Float {
        return soundLevel
    }
    func thereIsSoundAround() {
       //check parent online or not
        //if not send message via push notification(firebase)
        //prevent sent message always timelogic stop it for 1 minutes
        if !isParentDeviceOnline && timeLogic.value == true{
            firebaseService.iAmCrying()
            timeLogic.send(false)
            return
        }else if !isParentDeviceOnline && timeLogic.value == false{
            return
        }
        //there wasn't any sound before
        if !isSoundGoOn{
            smartListenerProtocol?.stopToListen()
            DispatchQueue.main.asyncAfter(deadline: .now()+1) { [unowned self] in
                agoraService?.startBroadcast()
            }
        }
        delegate?.handleOutputs(.soundComing(true))
        //prevent timer repeat itself continuously
        resetTimer?.invalidate()
        stopTimer?.invalidate()
        // now there is a sound
        isSoundGoOn = true
        resetTimer = Timer.scheduledTimer(withTimeInterval: 16, repeats: false, block: { [unowned self] _ in
            //there isn't sound for 10 seconds
            isSoundGoOn = false
        })
        stopTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: false, block: { [unowned self] _ in
            //sound isn't heard any more
            stopBroadcast()
        })
    }
    private func stopBroadcast(){
        if !isSoundGoOn{
            agoraService?.stopBroadcast()
            delegate?.handleOutputs(.soundComing(false))
        }
    }
}

extension ListenBabyViewModel:AgoraMessageServiceProtocol{
    
    func listenerOrSpeaker(_ listener: Bool) {
        //if it value is false, smart listener must be stop and agora audio must listen continuously
        if listener{
            smartListenerProtocol.startToListen()
            stopBroadcast()
        }else{//parent device is audience
            smartListenerProtocol.stopToListen()
            agoraService.startBroadcast()
        }
    }
    func selectConnectionType(type: ConnectionSource) {
        switch type {
        case .video:
            smartListenerProtocol.stopToListen()
            source = .video
        case .audio:
            smartListenerProtocol.startToListen()
            source = .audio
        }
    }
    
    func didOtherDeviceConnect(_ logic: Bool) {
        isParentDeviceOnline = logic
    }
    func turnCamera() {
        if videoService != nil{
            videoService.turnCamera()
        }
    }
}

//extension ListenBabyViewModel:SoundPlayerDelegate{
//    func errorType(_ error: SoundPlayerError) {
//
//    }
//
//    private func playWhiteSound(){
//        stopAudio()
//        player = SoundPlayer()
//        player.delegate = self
//        player.playSound()
//    }
//
//    private func stopWhiteSound(){
//        player.stopSound()
//        player = nil
//        startAudio()
//    }
//}



