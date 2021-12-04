//
//  ListenBabyViewControl.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 12.08.2021.
//
import Foundation


final class ListenBabyViewModel:ListenBabyViewModelProtocol{
    weak var delegate: ListenBabyViewModelDelegate?
    var router:ListenBabyRouter!
    var smartListenerProtocol:SmartListenerProtocol!
    var tokenDelegate: TokenServiceProtocol?
    let userName = "baby"
    var firebaseService: FirebaseAgoraService!
    var agoraService: AgoraAudioService!
    var videoService: AgoraVideoService!
    var token: String!
    var rtmToken:String!
    var channelID: String!
    
    var notification:NotificationCenter!
    var source:ConnectionSource?{
        didSet{
            switch source {
            case .video:
                stopEverything()
                startVideoBroadcast()
            case .audio:
                startEverything()
            default:
                break
            }
        }
    }
    
    
    
    var soundLevel:Float = -20
    var resetTimer:Timer?
    var stopTimer:Timer?
    var isSoundGoOn:Bool = false
    
    init() {
        notification = NotificationCenter
            .default
        notification.addObserver(self, selector: #selector(selectConnectionType), name: .notificationVideoOrAudio, object: nil)
    }
  
    
    @objc func startSmartAgain(){
        smartListenerProtocol?.startToListen()
    }
    
    @objc func selectConnectionType(notification:Notification){
        guard let _source = notification.object as? ConnectionSource else {return}
       source = _source
    }
    
    deinit {
      myPrint()
        
    }
    
    //user press button
    //first check isthere anybody in channel
    // then retur mutual channel id
    // then create token
    // create service
    // listen to medium
    // than send
    
    func startEverything() {
        notification.addObserver(self, selector: #selector(startSmartAgain), name: .notificationStartSmartListener, object: nil)
        firebaseService.decideAboutChannel(){ [unowned self]result in
            switch result{
            case .success(let response):
                guard let response = response else {fatalError("empty result")}
                if response == "success"{
                    firebaseService.enterTheChannel(role: .baby)
                }else{
                    printNew("faillllll")
                }
             
            case.failure(let error):
                printNew(error.localizedDescription)
            }
        }
        smartListenerProtocol?.startToListen()
        delegate?.handleOutputs(.connected)
        delegate?.handleOutputs(.isLoading(true))
        
        
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
    
    func stopEverything(){
        agoraService?.pauseBroadcast()
        smartListenerProtocol.stopToListen()
        notification.removeObserver(self, name: .notificationStartSmartListener, object: nil)
        smartListenerProtocol.deleteAllTimer()
        deleteAllTimer()
    }
    
    func startBroadcast(_ channel:String) {
        tokenDelegate?.fetchRtcToken( channel: channel) {[unowned self] tokenResult in
            switch tokenResult{
            case.failure(let error):
                delegate?.handleOutputs(.isLoading(false))
                delegate?.handleOutputs(.anyErrorOccurred(error.localizedDescription))
            case .success(let _token):
                guard let _token = _token else {return}
                token = _token
                
                tokenDelegate?.fetchRtmToken(userName:userName){ rtmTokenResult in
               
                    switch rtmTokenResult{
                    case.failure(let error):
                        delegate?.handleOutputs(.isLoading(false))
                        delegate?.handleOutputs(.anyErrorOccurred(error.localizedDescription))
                    case .success(let _rtmToken):
                        guard let _rtmToken = _rtmToken else {return}
                        rtmToken = _rtmToken
                        print(channelID)
                        printNew("token : \(token)")
                        printNew("rtmToken\(rtmToken)")
                        agoraService = AgoraAudioService( rtmToken: rtmToken, token: token, channel: channel, username: "baby", role: .broadcaster)
                        delegate?.handleOutputs(.isLoading(false))
                    }
                }
            }
        }
    }
    
    func returnSelect() {
        stopEverything()
        firebaseService.exitTheChannel(role: .baby) {[unowned self] _ in
            smartListenerProtocol = nil
            notification = nil
            stopTimer = nil
            resetTimer = nil
            router.routeTo(.toSelectPage)
        }
    }
    
    func setPrecision(_ soundTreshold: Float) {
        soundLevel = soundTreshold
    }
    
    func testItself() {
        
    }
    
    func deleteAllTimer(){
        stopTimer?.invalidate()
        resetTimer?.invalidate()
    }
    
    func startVideoBroadcast(){
        defer{
            videoService.connectAgoraVideo()
        }
        videoService = AgoraVideoService(token: token, channel: channelID, username: "baby", role: .broadcaster)
    }
    
    func stopVideoBroadcast(){
        
        videoService = nil
    }
}

extension ListenBabyViewModel:SmartListenerDelegate{
    func setSoundLevel() -> Float {
        return soundLevel
    }
    
    func thereIsSoundAround() {
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
            agoraService?.pauseBroadcast()
            delegate?.handleOutputs(.soundComing(false))
            
        }
    }
    
}



