//
//  AppSingleton.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 11.08.2021.
//

import CoreGraphics
import Foundation

class AppSingleton{
    static let sharedInstance = AppSingleton()
    var fcnDidChangelogic: Bool = false
    var safeTopHeight:CGFloat = 0
    var safeBottomHeight:CGFloat = 0
    private init(){ }
}
