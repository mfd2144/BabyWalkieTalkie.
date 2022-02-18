//
//  CustomViewProtocol.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 14.01.2022.
//

import Foundation

protocol  CustomViewDelegate:AnyObject {
    func buttonPressed()
    func broadcastPausePlay()
}

protocol CustomViewProtocol:AnyObject{
    func setColor(_ color: CustomViewColor)
    func setTitle(_ title :String)
}
