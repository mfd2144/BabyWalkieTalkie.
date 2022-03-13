//
//  AgoraAudioService.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 22.10.2021.
//

import Foundation
import AgoraRtcKit

class AgoraAudioService: NSObject {
    var channel: String
    //var appId = "3d3cffb6fa994521b3e0617bb8063577"
    var token: String?
    var username: String
    var role: AgoraClientRole = .broadcaster
    var delegate: AgoraAudioServicePorotocol?
    var agkit: AgoraRtcEngineKit?
    var userID: UInt = 0
    
    init(token: String?, channel: String, username: String, role: AgoraClientRole) {
        printNew("agora service init")
        self.token = token
        self.channel = channel
        self.username = username
        self.role = role
        super.init()
    }
    deinit {
        print("Agora deinit")
    }
    private func connectAgora() {
        // Create connection to RTC
        agkit = AgoraRtcEngineKit.sharedEngine(withAppId: appID, delegate: self)
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
            }
        )
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
    
}

extension AgoraAudioService: AgoraRtcEngineDelegate {
    func rtcEngine(
        _ engine: AgoraRtcEngineKit,
        remoteAudioStateChangedOfUid uid: UInt, state: AgoraAudioRemoteState,
        reason: AgoraAudioRemoteStateReason, elapsed: Int) {
        switch state {
        case .decoding, .starting:
            break
        case .stopped, .failed:
            break
        default:
            return
        }
    }
    func rtcEngine(_ engine: AgoraRtcEngineKit, activeSpeaker speakerUid: UInt) {
    }
}

extension AgoraAudioService{
    func startBroadcast() {
        connectAgora()
    }
    func stopBroadcast(){
        pause()
    }
    func makeSpeaker(){
        agkit?.setClientRole(.broadcaster)
    }
    func makeListener(){
        agkit?.setClientRole(.audience)
    }
}


