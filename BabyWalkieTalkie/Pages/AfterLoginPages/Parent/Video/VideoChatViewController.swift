//
//  VideoChatViewController.swift
//  Agora iOS Tutorial
//
//  Created by James Fang on 7/14/16.
//  Copyright © 2016 Agora.io. All rights reserved.
//

import UIKit
import AgoraRtcKit

class VideoChatViewController: UIViewController {
    
    @IBOutlet weak var remoteContainer: UIView!
    let turnButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "switch"), for: .normal)
        return button
    }()
    let micButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "mic"), for: .normal)
        return button
    }()
    
    
    weak var parentView:ParentView!
    weak var logVC: LogViewController?
    var agoraKit: AgoraRtcEngineKit!
    var messageService:AgoraMessageService!
    var remoteVideo: AgoraRtcVideoCanvas?
    var token:String?
    var channelID:String?
    var appId:String?
    var firebaseService : FirebaseAgoraService!
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        appId = AppSingleton.sharedInstance.appID
        initializeVideo()
        setSubViews()
    }
 
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        leaveChannel()
        messageService.sendMessage(.audio)
        parentView.viewModel.setAgora()
    }
    
    private func setSubViews(){
        remoteVideo?.view?.layer.zPosition = -100
       
        view.addSubview(micButton)
        view.addSubview(turnButton)
        micButton.layer.zPosition = 100
        turnButton.layer.zPosition = 100
        micButton.addTarget(self, action: #selector(didClickMuteButton(_ :)), for: .touchUpInside)
        turnButton.addTarget(self, action: #selector(turnButtonClicked(_ :)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            micButton.widthAnchor.constraint(equalToConstant: buttonSize),
            micButton.heightAnchor.constraint(equalTo: micButton.widthAnchor),
            micButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            micButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -1*buttonSize),
            turnButton.widthAnchor.constraint(equalToConstant: buttonSize),
            turnButton.heightAnchor.constraint(equalTo: turnButton.widthAnchor),
            turnButton.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: view.frame.width/4),
            turnButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -1*buttonSize),
        ])
    }
    
    func initializeVideo() {
        firebaseService = FirebaseAgoraService(role: .parent)
        guard let appId = appId else{
            //todo
            // show error code ?
            return
        }
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: self)
        joinChannel()
        setupVideo()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        if identifier == "EmbedLogViewController",
           let vc = segue.destination as? LogViewController {
            self.logVC = vc
        }
    }
    func setupVideo() {
        // In simple use cases, we only need to enable video capturing
        // and rendering once at the initialization step.
        // Note: audio recording and playing is enabled by default.
        agoraKit.enableVideo()
        // Set video configuration
        // Please go to this page for detailed explanation
        agoraKit
            .setVideoEncoderConfiguration(AgoraVideoEncoderConfiguration(size:
                                                                            AgoraVideoDimension640x360,
                                                                         frameRate: .fps15,
                                                                         bitrate: AgoraVideoBitrateStandard,
                                                                         orientationMode: .adaptative))
    }

    func joinChannel() {
        guard let token = token, let channelID = channelID else {
            return
        }
        
        // Set audio route to speaker
        agoraKit.setDefaultAudioRouteToSpeakerphone(true)
        
        // 1. Users can only see each other after they join the
        // same channel successfully using the same app id.
        // 2. One token is only valid for the channel name that
        // you use to generate this token.
        agoraKit.joinChannel(byToken: token, channelId: channelID, info: nil, uid: 1) { [unowned self] (channel, uid, elapsed) -> Void in
            // Did join channel "demoChannel1"
            self.logVC?.log(type: .info, content: Local2.joinChannel)
        }
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func leaveChannel() {
        // leave channel and end chat
        agoraKit.leaveChannel(nil)
        UIApplication.shared.isIdleTimerDisabled = false
        self.logVC?.log(type: .info, content: Local2.leaveChannel)
        agoraKit = nil
    }
    @objc func didClickMuteButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        // mute local audio
        if sender.isSelected{
            sender.setImage(UIImage(named: "mute"), for: .normal)
        }else{
            sender.setImage(UIImage(named: "mic"), for: .normal)
        }
        agoraKit.muteLocalAudioStream(sender.isSelected)
    }
    
    
    @objc func turnButtonClicked(_ sender: UIButton) {
        messageService.sendMessage(.turnCamera)
    }
    
    func removeFromParent(_ canvas: AgoraRtcVideoCanvas?) -> UIView? {
        if let it = canvas, let view = it.view {
            let parent = view.superview
            if parent != nil {
                view.removeFromSuperview()
                return parent
            }
        }
        return nil
    }
    
}

extension VideoChatViewController: AgoraRtcEngineDelegate {
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {

        var parent: UIView = remoteContainer
        // Only one remote video view is available for this
        // tutorial. Here we check if there exists a surface
        // view tagged as this uid.
        if remoteVideo != nil {
            return
        }
        let view = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: remoteContainer.frame.size))
        remoteVideo = AgoraRtcVideoCanvas()
        remoteVideo!.view = view
        remoteVideo!.renderMode = .hidden
        remoteVideo!.uid = uid
        parent.addSubview(remoteVideo!.view!)
        agoraKit.setupRemoteVideo(remoteVideo!)
        
    }
    
    /// Occurs when a remote user (Communication)/host (Live Broadcast) leaves a channel.
    /// - Parameters:
    ///   - engine: RTC engine instance
    ///   - uid: ID of the user or host who leaves a channel or goes offline.
    ///   - reason: Reason why the user goes offline
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid:UInt, reason:AgoraUserOfflineReason) {
        self.logVC?.log(type: .info, content: Local2.otherDeviceLeave)
//        isRemoteVideoRender = false
//        if let it = remoteVideo, it.uid == uid {
//            removeFromParent(it)
//            remoteVideo = nil
//        }
    }
    
    /// Occurs when a remote user’s video stream playback pauses/resumes.
    /// - Parameters:
    ///   - engine: RTC engine instance
    ///   - muted: YES for paused, NO for resumed.
    ///   - byUid: User ID of the remote user.
    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoMuted muted:Bool, byUid:UInt) {
//        isRemoteVideoRender = !muted
    }
    
    /// Reports a warning during SDK runtime.
    /// - Parameters:
    ///   - engine: RTC engine instance
    ///   - warningCode: Warning code
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode) {
        logVC?.log(type: .warning, content: " \(Local2.logWarning) \(warningCode.rawValue)")
    }
    
    /// Reports an error during SDK runtime.
    /// - Parameters:
    ///   - engine: RTC engine instance
    ///   - errorCode: Error code
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        logVC?.log(type: .error, content: "\(Local2.logError) \(errorCode.rawValue)")
    }
}


