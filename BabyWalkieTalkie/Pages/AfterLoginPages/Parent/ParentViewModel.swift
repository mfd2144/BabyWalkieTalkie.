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
    var agoraVideoService : AgoraVideoService?
    var token:String?
    var rtmToken:String?
    var channelID:String?
    
    deinit{
        myPrint()
    }
    
    
    func startEverything() {
        delegate?.handleOutputs(outputs: .isLoading(true))
        // check channel condition,change channel role as parent
        firebaseService.decideAboutChannel(){ [unowned self]result in
            switch result{
            case .success(let response):
                guard let response = response else {fatalError("empty result")}
                if response == "success"{
                    firebaseService.enterTheChannel(role: .parent)
                }else{
                    //failde hata verip otomatik geri gitmeli
                }
             
            case.failure(let error):
                printNew(error.localizedDescription)
            }
        }
        
        //fetch channelID
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
                        guard let _token = _token else {return}
                        token = _token
                        //fetch ftm token
                        tokenDelegate.fetchRtmToken(userName:userName) { rtmTokenResult in
                            delegate?.handleOutputs(outputs: .isLoading(false))
                            switch rtmTokenResult{
                            case.failure(let error):
                                delegate?.handleOutputs(outputs: .anyErrorOccurred(error.localizedDescription))
                            case .success(let _rtmToken):
                                guard let _rtmToken = _rtmToken else {return}
                                rtmToken = _rtmToken
                                
                                setAgora(rtmToken: _rtmToken, token: _token, channelID: _channelID)
                            }
                        }
                   
                                              
                    }
                }
            }
        }
    
    }
    
    func setAgora(rtmToken:String,token:String,channelID:String){
        self.agoraService = AgoraAudioService(rtmToken: rtmToken, token: token, channel: channelID, username:"parent" , role:.audience)
        
         agoraService?.startBroadcast()
    }
    
    func  testPressed(){
        guard let agoraService = agoraService else { return }
        agoraService.sendMessage(.test)
        
    }
    
    func speakPressed(){
        agoraService.role = .broadcaster
    }
    
    func videoPressed(){
        agoraService.pauseBroadcast()
        guard let token = token ,
        let channelID = channelID else {return}
        router.toVideo(channelID: channelID, token: token)
    }

    
    func returnSelect() {
        delegate?.handleOutputs(outputs: .isLoading(true))
        firebaseService.exitTheChannel(role: .parent) { [unowned self]_ in
            delegate?.handleOutputs(outputs: .isLoading(false))
            firebaseService = nil
            tokenDelegate = nil
            router.toSelectView()
        }
    }
  
}



