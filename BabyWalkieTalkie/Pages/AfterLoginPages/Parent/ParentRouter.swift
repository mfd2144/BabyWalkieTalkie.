//
//  ParentRouter.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 11.10.2021.
//

import UIKit

final class ParentRouter:ParetRouterProtocol{

    
    unowned var view:ParentView!
    func toSelectView() {
        view.dismiss(animated: true)
    }
    func toVideo(channelID:String,token:String,messageService: AgoraMessageService){
        guard let videoController = VideoChatBuilder.make(token: token, channelID: channelID,messageService: messageService) else {return}
        view.present(videoController, animated: true)
    }
}

