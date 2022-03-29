//
//  SmartNotification.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 20.08.2021.
//

import Foundation

extension Notification.Name{
    static let notificationStartSmartListener = Notification.Name("NotificationStartSmartListener")
    static let notificationVideoOrAudio = Notification.Name("NotificationVideoOrAudio")
    static let notificationPageControl = Notification.Name("NotificationPageControl")
}
extension Notification.Name {
    static let IAPHelperPurchaseNotification = Notification.Name("IAPHelperPurchaseNotification")
}

