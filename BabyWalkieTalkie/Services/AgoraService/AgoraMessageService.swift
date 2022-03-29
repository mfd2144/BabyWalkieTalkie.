//
//  AgoraMessageService.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 9.12.2021.
//

import Foundation
import AgoraRtmKit

@objc protocol AgoraMessageServiceProtocol{
    @objc optional func testOK()
    @objc optional func whiteSound()
    @objc optional func turnCamera()
    func didOtherDeviceConnect(_ logic:Bool)
    @objc optional func selectConnectionType(type:ConnectionSource)
    @objc optional func listenerOrSpeaker(_ listener:Bool)
    func agoraServiceError(errorString:String)
}

class AgoraMessageService: NSObject{
    var channel: String
    var rtmToken:String?
    var username: String
    var delegate:AgoraMessageServiceProtocol?
    var appId:String?
    
    init(rtmToken:String?,  channel: String, username: String) {
        self.channel = channel
        self.username = username
        self.rtmToken = rtmToken
        self.appId = AppSingleton.sharedInstance.appID
        super.init()
        connectAgora()
    }

    var rtmkit: AgoraRtmKit?
    var rtmChannel: AgoraRtmChannel?{
        didSet{
            joinChannel()
        }
    }
    
    private func connectAgora() {
        // Create connection to RTM
        guard let appId = appId else {
            delegate?.agoraServiceError(errorString: Local2.agoraError)
            return
        }
        rtmkit = AgoraRtmKit(appId: appId, delegate: self)
        rtmkit?.login(byToken: self.rtmToken, user: self.username)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[unowned self] in
            rtmChannel = rtmkit?.createChannel(withId: channel, delegate: self)
        }
    }
private func joinChannel() {
        self.rtmChannel?.join(completion: { [unowned self] (errcode) in
            if errcode == .channelErrorOk {
                rtmChannel?.getMembersWithCompletion({[unowned self] numberOfMember, _ in
                    if numberOfMember?.count == 2{
                        delegate?.didOtherDeviceConnect(true)
                    }else{
                        delegate?.didOtherDeviceConnect(false)
                    }
                })
              
            }else{
                //todo
                delegate?.agoraServiceError(errorString: Local.unknownError)
            }
        })
    }
    
    private func disconnect() {
         self.rtmChannel?.leave()
         self.rtmkit?.logout()
         self.rtmkit?.destroyChannel(withId: self.channel)
         rtmkit = nil
         rtmChannel = nil
     }
    
    private func shareUserComment(comment:MessageComment,to username: String? = nil) {
        if let user = username {
            self.rtmkit?.send(AgoraRtmMessage(text: comment.rawValue), toPeer: user)
        } else {
            self.rtmChannel?.send(AgoraRtmMessage(text: comment.rawValue))
        }
    }
}

extension AgoraMessageService:AgoraRtmDelegate,AgoraRtmChannelDelegate{
    func channel(_ channel: AgoraRtmChannel, memberJoined member: AgoraRtmMember) {
        delegate?.didOtherDeviceConnect(true)
    }

    func channel(_ channel: AgoraRtmChannel, memberLeft member: AgoraRtmMember) {
        delegate?.didOtherDeviceConnect(false)
    }
    func channel(
        _ channel: AgoraRtmChannel,
        messageReceived message: AgoraRtmMessage, from member: AgoraRtmMember
    ) {
        guard let comment = MessageComment.init(rawValue: message.text) else {return }
        switch comment {
        case .test:
            shareUserComment(comment: .testOK, to: nil)//done
        case .video:
            delegate?.selectConnectionType?(type: .video)//done
        case .audio:
            delegate?.selectConnectionType?(type: .audio)//done
        case .whiteSound:
            delegate?.whiteSound?()
             case.testOK:
            delegate?.testOK?()//done
        case .speaker:
            delegate?.listenerOrSpeaker?(false)//done
        case .listener:
            delegate?.listenerOrSpeaker?(true)//done
        case .turnCamera:
            delegate?.turnCamera?()
        }
    }

    func rtmKit(
        _ kit: AgoraRtmKit,
        messageReceived message: AgoraRtmMessage, fromPeer peerId: String
    ) {    }
    
}
extension AgoraMessageService{
    func sendMessage(_ message: MessageComment){
        shareUserComment(comment: message, to: nil)
    }
}






