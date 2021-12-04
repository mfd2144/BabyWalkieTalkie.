//
//  AgoraAudioService.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 22.10.2021.
//

import Foundation
import AgoraRtcKit
import AgoraRtmKit


class AgoraMessageService: NSObject, AgoraRtmDelegate, AgoraRtmChannelDelegate{
    var channel: String
    var appId = "3d3cffb6fa994521b3e0617bb8063577"
    var rtmToken:String?
    var username: String
    
    init(rtmToken:String?,  channel: String, username: String) {
        self.channel = channel
        self.username = username
        self.rtmToken = rtmToken
        super.init()
    }
    deinit {
        print("Agora  message deinit")
    }

    var rtmkit: AgoraRtmKit?
    var rtmChannel: AgoraRtmChannel?
    
    private func connectAgora() {
        // Create connection to RTM
        rtmkit = AgoraRtmKit(appId: self.appId, delegate: self)
        rtmkit?.login(byToken: self.rtmToken, user: self.username)
        rtmChannel = rtmkit?.createChannel(withId: channel, delegate: self)
        joinChannel()
    }

    
    private func joinChannel() {
        self.rtmChannel?.join(completion: { (errcode) in
            if errcode == .channelErrorOk {
               
            }
        })
    
       
    }



}


class AgoraAudioService: NSObject {
    
    var channel: String
    var appId = "3d3cffb6fa994521b3e0617bb8063577"
    var token: String?
    var rtmToken:String?
    var username: String
    var role: AgoraClientRole = .broadcaster
    var delegate: AgoraAudioServicePorotocol?
    
    init(rtmToken:String?, token: String?, channel: String, username: String, role: AgoraClientRole) {
        
        self.token = token
        self.channel = channel
        self.username = username
        self.rtmToken = rtmToken
        self.role = role
        super.init()
    }
    
    deinit {
        print("Agora deinit")
    }

    var agkit: AgoraRtcEngineKit?
    var rtmkit: AgoraRtmKit?
    var rtmChannel: AgoraRtmChannel?
    var userID: UInt = 0
//    var activeSpeakers: Set<UInt> = []
//    var activeSpeaker: UInt?
//    var activeAudience: Set<UInt> = []
//    var usernameLookups: [UInt: String] = [:]

    private func connectAgora() {
        // Create connection to RTM
        rtmkit = AgoraRtmKit(appId: self.appId, delegate: self)
        rtmkit?.login(byToken: self.rtmToken, user: self.username)
        rtmChannel = rtmkit?.createChannel(withId: channel, delegate: self)
        

        // Create connection to RTC
        agkit = AgoraRtcEngineKit.sharedEngine(withAppId: self.appId, delegate: self)
        agkit?.enableAudio()
        agkit?.enableAudioVolumeIndication(1000, smooth: 3, report_vad: true)
        agkit?.setChannelProfile(.liveBroadcasting)
        agkit?.setClientRole(role)
        joinChannel()
    }
    
   
    
    

    private func joinChannel() {
        // Connect to Audio RTC
        agkit?.joinChannel(
            byToken: self.token, channelId: self.channel,
            info: nil, uid: self.userID,
            joinSuccess: { (_ , uid, elapsed) in
                self.userID = uid
//                if self.role == .audience {
//                    self.activeAudience.insert(uid)
//                } else {
//                    self.activeSpeakers.insert(uid)
//                }
//                self.usernameLookups[uid] = self.username
                
                // Connect to RTM Channel
                self.rtmChannel?.join(completion: { (errcode) in
                    if errcode == .channelErrorOk {
                       
                    }
                })
            }
        )
       
    }

    private func shareUserComment(comment:MessageComment,to username: String? = nil) {
        if let user = username {
            self.rtmkit?.send(AgoraRtmMessage(text: comment.rawValue), toPeer: user)
        } else {
            self.rtmChannel?.send(AgoraRtmMessage(text: comment.rawValue))
        }
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func pause(){
        self.agkit?.createRtcChannel(self.channel)?.leave()
        self.agkit?.leaveChannel()
        agkit = nil
        AgoraRtcEngineKit.destroy()
        NotificationCenter.default.post(name: .notificationStartSmartListener, object: nil)
        
    }
    

   private func disconnect() {
        self.rtmChannel?.leave()
        self.rtmkit?.logout()
        self.rtmkit?.destroyChannel(withId: self.channel)
        rtmkit = nil
        rtmChannel = nil
       pause()
        
    }
}

extension AgoraAudioService: AgoraRtcEngineDelegate {
    
    func rtcEngine(
        _ engine: AgoraRtcEngineKit,
        remoteAudioStateChangedOfUid uid: UInt, state: AgoraAudioRemoteState,
        reason: AgoraAudioRemoteStateReason, elapsed: Int) {
   
        switch state {
        case .decoding, .starting:
//            self.activeAudience.remove(uid)
//            self.activeSpeakers.insert(uid)
            break
        case .stopped, .failed:
//            self.activeSpeakers.remove(uid)
            break
        default:
            return
        }
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, activeSpeaker speakerUid: UInt) {
//        self.activeSpeaker = speakerUid
    }
}

//MARK: - Real Time Message
extension AgoraAudioService: AgoraRtmDelegate, AgoraRtmChannelDelegate {
    func channel(_ channel: AgoraRtmChannel, memberJoined member: AgoraRtmMember) {
        print(member.userId)
        printNew("memberJoined")
    }

    func channel(_ channel: AgoraRtmChannel, memberLeft member: AgoraRtmMember) {
        printNew("memberleft")
//           guard let uid = self.usernameLookups.first(where: { (keyval) -> Bool in
//            keyval.value == member.userId
//        })?.key else {
//            print("Could not find member \(member.userId)")
//            return
//        }
//        self.activeAudience.remove(uid)
//        self.activeSpeakers.remove(uid)
//        self.usernameLookups.removeValue(forKey: uid)
    }
    

    func channel(
        _ channel: AgoraRtmChannel,
        messageReceived message: AgoraRtmMessage, from member: AgoraRtmMember
    ) {
        print("messageReceived -1")
        print(message.text)
        guard let comment = MessageComment.init(rawValue: message.text) else {return }
        print(comment.rawValue)
    }


    func rtmKit(
        _ kit: AgoraRtmKit,
        messageReceived message: AgoraRtmMessage, fromPeer peerId: String
    ) {
        print("messageReceived -2")
        print(message.text)
    }


    // New message from peer
    // - Parameters:
    //   - message: Message text, containing the user's RTC id.
    //  - username: Username of the user who send the message
//    func newMessage(_ comment: MessageComment, from username: String) {
//        if let uidMessage = UInt(comment.rawValue) {
//            usernameLookups[uidMessage] = username
//            printNew("ıjjoıjo")
//            // If we haven't seen this userID yet, add them to the audience
//            if !self.activeAudience.union(self.activeSpeakers).contains(uidMessage) {
//                self.activeAudience.insert(uidMessage)
//            }
//        }
//    }
    
    
}


extension AgoraAudioService{
    func startBroadcast() {
        connectAgora()
    }
    

    func pauseBroadcast() {
      pause()
    }
    
    func stopBroadcast(){
        disconnect()
    }
    
    func sendMessage(_ message: MessageComment){
        shareUserComment(comment: .test, to: nil)
    }
    func makeSpeaker(){
        agkit?.setClientRole(.broadcaster)
    }
    func makeListener(){
        
    }
}


enum Orders{
    case test
}

protocol AgoraAudioServicePorotocol:AnyObject{
    func test(_ order:Orders)
}


enum MessageComment:String{
    case test
    case video
    case audio
    case whiteSound
}
