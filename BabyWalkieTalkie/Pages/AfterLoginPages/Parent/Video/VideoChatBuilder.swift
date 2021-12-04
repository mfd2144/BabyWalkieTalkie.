//
//  VideoChatBuilder.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 27.10.2021.
//

import UIKit

final class VideoChatBuilder{
    static func make(token:String,channelID:String)->UIViewController?{
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let firebaseService = FirebaseAgoraService(role: .parent)
        guard let videoController = storyBoard.instantiateViewController(withIdentifier: "VideoController") as? VideoChatViewController else {return nil}
        videoController.token  = token
        videoController.firebaseService = firebaseService
        videoController.channelID = channelID
        return videoController
    }
}