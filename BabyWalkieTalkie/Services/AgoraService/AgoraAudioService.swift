//
//  AgoraAudioService.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 22.10.2021.
//

import Foundation
import AgoraRtcKit

protocol AgoraAudioServicePorotocol:AnyObject{
    func memberCondition(_ bool:Bool)
}

class AgoraAudioService: NSObject {
    var channel: String
    var appId:String?
    var token: String?
    var username: String
    var role: AgoraClientRole = .broadcaster
    var delegate: AgoraAudioServicePorotocol?
    var agkit: AgoraRtcEngineKit?
    var userID: UInt = 0
    var lastStat:Int = 1
    
    init(token: String?, channel: String, username: String, role: AgoraClientRole) {
        self.token = token
        self.channel = channel
        self.username = username
        self.role = role
        self.appId = AppSingleton.sharedInstance.appID
        super.init()
    }

    private func connectAgora() {
        guard let appId = appId else {
            //todo
            //add delegate
            return
        }
        // Create connection to RTC
        agkit = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: self)
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
    func rtcEngine(_ engine: AgoraRtcEngineKit, reportRtcStats stats: AgoraChannelStats) {
        // crying light
        if stats.userCount != lastStat{
            lastStat = stats.userCount
            stats.userCount == 1 ? delegate?.memberCondition(false): delegate?.memberCondition(true)
        }
    }
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


