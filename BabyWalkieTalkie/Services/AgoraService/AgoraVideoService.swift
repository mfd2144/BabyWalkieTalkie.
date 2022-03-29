import AgoraRtcKit
import UIKit

class AgoraVideoService:NSObject{
    var channel: String
    var appID:String?
    var token: String?
    var username: String
    var role: AgoraClientRole = .broadcaster
    var agkit: AgoraRtcEngineKit?
    var userID: UInt = 0
    var activeSpeakers: Set<UInt> = []
    var activeSpeaker: UInt?
    var activeAudience: Set<UInt> = []
    var usernameLookups: [UInt: String] = [:]

    init(token: String, channel: String, username: String, role: AgoraClientRole) {
        self.token = token
        self.channel = channel
        self.username = username
        self.role = role
        super.init()
        self.appID = AppSingleton.sharedInstance.appID
    }
    func connectAgoraVideo(){
        initializeAgoraEngine()
        setupVideo()
        setupLocalVideo()
        joinChannel()
    }
    func disconnectAgoraVideo(){
        agkit?.createRtcChannel(channel)?.leave()
        agkit?.leaveChannel()
        agkit = nil
    }

    func joinChannel() {
        // Set audio route to speaker
        agkit?.setDefaultAudioRouteToSpeakerphone(true)
        // 1. Users can only see each other after they join the
        // same channel successfully using the same app id.
        // 2. One token is only valid for the channel name that
        // you use to generate this token.
        agkit?.joinChannel(byToken: token, channelId: channel, info: nil, uid: 0) {(channel, uid, elapsed) -> Void in
            // Did join channel "demoChannel1"
        }
        //prevent screen to lock
        UIApplication.shared.isIdleTimerDisabled = true
    }

    func initializeAgoraEngine() {
        // init AgoraRtcEngineKit
        guard let appID = appID else {return}
        agkit = AgoraRtcEngineKit.sharedEngine(withAppId: appID, delegate: self)
    }

    func setupVideo() {
        // In simple use cases, we only need to enable video capturing
        // and rendering once at the initialization step.
        // Note: audio recording and playing is enabled by default.
        agkit?.enableVideo()

        // Set video configuration
        agkit?.setVideoEncoderConfiguration(AgoraVideoEncoderConfiguration(size: AgoraVideoDimension640x360,
                                                                             frameRate: .fps15,
                                                                             bitrate: AgoraVideoBitrateStandard,
                                                                             orientationMode: .adaptative))
    }

    func setupLocalVideo() {
        // This is used to set a local preview.
        // The steps setting local and remote view are very similar.
        // But note that if the local user do not have a uid or do
        // not care what the uid is, he can set his uid as ZERO.
        // Our server will assign one and return the uid via the block
        // callback (joinSuccessBlock) after
        // joining the channel successfully.
        agkit?.startPreview()
    }

    func joinVideoChannel(){
        // Set audio route to speaker
        agkit?.setDefaultAudioRouteToSpeakerphone(true)

        // 1. Users can only see each other after they join the
        // same channel successfully using the same app id.
        // 2. One token is only valid for the channel name that
        // you use to generate this token.
        agkit?.joinChannel(byToken: token, channelId: channel, info: nil, uid: userID) { (channel, uid, elapsed) -> Void in
            // Did join channel "demoChannel1"
            //todo?

        }
        UIApplication.shared.isIdleTimerDisabled = true
    }

    func startVideo(){
        connectAgoraVideo()
    }
    func turnCamera() {
        agkit?.switchCamera()
    }



}

extension AgoraVideoService:AgoraRtcEngineDelegate{

    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
    }

    /// Occurs when a remote user (Communication)/host (Live Broadcast) leaves a channel.
    /// - Parameters:
    ///   - engine: RTC engine instance
    ///   - uid: ID of the user or host who leaves a channel or goes offline.
    ///   - reason: Reason why the user goes offline
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid:UInt, reason:AgoraUserOfflineReason) {

        }


    /// Occurs when a remote user’s video stream playback pauses/resumes.
    /// - Parameters:
    ///   - engine: RTC engine instance
    ///   - muted: YES for paused, NO for resumed.
    ///   - byUid: User ID of the remote user.
    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoMuted muted:Bool, byUid:UInt) {

    }

    /// Reports a warning during SDK runtime.
    /// - Parameters:
    ///   - engine: RTC engine instance
    ///   - warningCode: Warning code
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode) {

    }

    /// Reports an error during SDK runtime.
    /// - Parameters:
    ///   - engine: RTC engine instance
    ///   - errorCode: Error code
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {

    }


}
