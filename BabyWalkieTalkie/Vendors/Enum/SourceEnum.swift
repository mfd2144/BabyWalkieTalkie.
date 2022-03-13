//
//  SourceEnum.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 27.10.2021.
//

import Foundation

@objc enum ConnectionSource:Int{
    case video
    case audio
    var sourceString:String{
        switch self{
        case.audio:return "audio"
        case.video:return "video"
        }
    }
}
