//
//  AppSingleton.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 11.08.2021.
//

import Foundation

class AppSingleton{
    static let sharedInstance = AppSingleton()
    var fcnDidChangelogic: Bool = false
    private init(){ }
}
