//
//  ParentViewControl.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 18.08.2021.
//

import Foundation


final class ParentViewModel:ParentViewModelProtocol{
    weak var delegate: ParentViewModelDelegate?
    var router: ParentRouter!
    var firebaseService :FirebaseAgoraService!
    var tokenDelegate : TokenServiceProtocol!
    let userName = "parent"
    var agoraService: AgoraAudioService!
    var agoraMessageService: AgoraMessageService!
    var agoraVideoService : AgoraVideoService?
    var token:String?
    var rtmToken:String?
    var channelID:String?
    var messageLogic :Bool = false
    var isListener:Bool = true
    var timer:Timer?
    var connectionStatus:Bool!
    var isBabyDeviceOnline:Bool = false
    
    deinit{
        print("parent deinit")
    }
    func startEverything(){
        delegate?.handleOutputs(outputs: .isLoading(true))
        // check channel condition,change channel role as parent
        firebaseService.decideAboutChannel(){ [unowned self]result in
            switch result{
            case .success(let response):
                guard let response = response else {fatalError("empty result")}
                if response != "parent" {
                    firebaseService.enterTheChannel(role: .parent)
                    otherWorks()
                }else{
                    delegate?.handleOutputs(outputs: .alreadyLogisAsParent)
                }
            case.failure:
                delegate?.handleOutputs(outputs: .thereNotPairedDevice)
            }
        }
    }
    private func otherWorks(){
        firebaseService.fetchChannelID { [unowned self] result in
            switch result{
            case.failure(let error):
                // fetch ID error
                delegate?.handleOutputs(outputs: .isLoading(false))
                delegate?.handleOutputs(outputs: .anyErrorOccurred(error.localizedDescription))
            case .success(let _channelID):
                guard let _channelID = _channelID else {return}
                channelID = _channelID
                //after channelID fetch rtc token
                tokenDelegate.fetchRtcToken( channel: _channelID) { tokenResult in
                    switch tokenResult{
                    case.failure(let error):
                        delegate?.handleOutputs(outputs: .isLoading(false))
                        delegate?.handleOutputs(outputs: .anyErrorOccurred(error.localizedDescription))
                    case .success(let _token):
                        token = _token
                        //fetch ftm token
                        tokenDelegate.fetchRtmToken(userName:userName) { rtmTokenResult in
                            switch rtmTokenResult{
                            case.failure(let error):
                                delegate?.handleOutputs(outputs: .anyErrorOccurred(error.localizedDescription))
                            case .success(let _rtmToken):
                                rtmToken = _rtmToken
                                setAgora()
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func setAgora(){
        guard let token = token,let rtmToken = rtmToken, let channelID = channelID  else {
            return
        }
        self.agoraService = AgoraAudioService( token: token, channel: channelID, username:"parent" , role:.audience)
        self.agoraMessageService = AgoraMessageService(rtmToken: rtmToken, channel: channelID, username: "parent")
        agoraMessageService.delegate = self
        agoraService?.startBroadcast()
        delegate?.handleOutputs(outputs: .isLoading(false))
    }
    
    func setAsWalkieTalkie() {
        //will start after video page
        if agoraMessageService != nil{
            agoraMessageService.sendMessage(.audio)
        }
    }
    func  testPressed(){
        guard let agoraMessageService = agoraMessageService else {
            delegate?.handleOutputs(outputs: .anyErrorOccurred("Try again"))
            return }
        delegate?.handleOutputs(outputs: .isLoading(true))
        agoraMessageService.sendMessage(.test)
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(testTimer), userInfo: nil, repeats: false)
    }
    @objc private func testTimer(){
        delegate?.handleOutputs(outputs: .isLoading(false))
        if !messageLogic{
            delegate?.handleOutputs(outputs: .testResult(false, "check your baby!!!"))
        }else{
            messageLogic = false
        }
    }
    func speakPressed(){
        guard let agoraMessageService = agoraMessageService else {
            delegate?.handleOutputs(outputs: .anyErrorOccurred("Try again"))
            return }
        if isListener {
            agoraService.makeSpeaker()
            agoraMessageService.sendMessage(.speaker)
            delegate?.handleOutputs(outputs:.listener(false) )
        }else{
            agoraService.makeListener()
            agoraMessageService.sendMessage(.listener)
            delegate?.handleOutputs(outputs: .listener(true))
        }
        isListener = !isListener
    }
    func videoPressed(){
        guard isBabyDeviceOnline else {delegate?.handleOutputs(outputs: .babyDeviceNotConnect); return}
        guard let agoraMessageService = agoraMessageService else {
            delegate?.handleOutputs(outputs: .anyErrorOccurred("Try again")); return }
        agoraMessageService.sendMessage(.video)
        agoraService.stopBroadcast()
        guard let token = token ,
              let channelID = channelID else {return}
        router.toVideo(channelID: channelID, token: token,messageService: agoraMessageService)
    }
    func closePressed() {
        firebaseService.exitTheChannel(role: .parent) { _ in}
        returnToSelectPage()
    }
    func returnToSelectPage(){
        if agoraService != nil{
            agoraService.stopBroadcast()
        }
        firebaseService = nil
        tokenDelegate = nil
        agoraMessageService = nil
        agoraService = nil
        agoraVideoService = nil
        timer?.invalidate()
        router.toSelectView()
    }
    func otherDeviceDidUnpair(){
        let matchService = FirebaseMatchService()
        matchService.disconnetUsers { [unowned self] results in
            switch results{
            case.success:
                delegate?.handleOutputs(outputs: .otherDeviceDidUnpair)
            default:
                break
            }
        }    }
}
extension ParentViewModel: AgoraMessageServiceProtocol{
    func listenerOrSpeaker(_ listener: Bool) { }//for baby
    func testOK() {
        let time = Date.actualStringTime()
        messageLogic = true
        timer?.invalidate()
        delegate?.handleOutputs(outputs: .isLoading(false))
        delegate?.handleOutputs(outputs:.testResult(true, time))
    }
    func whiteSound() { }//todo
    func didOtherDeviceConnect(_ logic: Bool) {
        isBabyDeviceOnline = logic
        delegate?.handleOutputs(outputs: .babyDeviceConnect(logic))
    }
    func selectConnectionType(type: ConnectionSource) { }//todo
}



