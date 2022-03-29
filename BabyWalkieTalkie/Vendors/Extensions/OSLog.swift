//
//  OSLog.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 18.03.2022.
//

import Foundation
import os.log

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!

    /// Logs the view cycles like viewDidLoad.
    static let viewCycle = OSLog(subsystem: subsystem, category: "viewcycle")
}
