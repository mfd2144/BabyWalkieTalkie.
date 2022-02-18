//
//  CustomViewColor.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 14.01.2022.
//

import Foundation
import class UIKit.UIColor

enum CustomViewColor{
    case inital
    case loading
    case sound
    case ready
    
    func setColor()->UIColor{
        switch self {
        case .inital:
            return UIColor.setColor(r: 61, g: 178, b: 255)
        case.loading:
            return UIColor.setColor(r: 255, g: 237, b: 218)
        case.ready:
            return UIColor.setColor(r: 255, g: 184, b: 66)
        case.sound:
            return UIColor.setColor(r: 255, g: 36, b: 66)
        }
    }
}
