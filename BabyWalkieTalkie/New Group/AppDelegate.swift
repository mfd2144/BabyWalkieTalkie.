//
//  AppDelegate.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 8.08.2021.
//

import UIKit
import Firebase
import UserNotifications
import FirebaseMessaging
import FBSDKCoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
      
        //Firebase configuration
        FirebaseApp.configure()
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        //Remote notification push
        setRemoteNotification(application)
        //Firebase cloud messaging
        Messaging.messaging().delegate = self
        //Reset badge number whenever app starts
        UIApplication.shared.applicationIconBadgeNumber = 0
        do {
            try Network.reachability = Reachability(hostname: "www.google.com")
        }
        catch {
            switch error as? Network.Error {
            case let .failedToCreateWith(hostname)?:
                print("Network error:\nFailed to create reachability object With host named:", hostname)
            case let .failedToInitializeWith(address)?:
                print("Network error:\nFailed to initialize reachability object With address:", address)
            case .failedToSetCallout?:
                print("Network error:\nFailed to set callout")
            case .failedToSetDispatchQueue?:
                print("Network error:\nFailed to set DispatchQueue")
            case .none:
                print(error)
            }
        }
        return true
    }
    
    private func setRemoteNotification(_ application:UIApplication){
        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().delegate = self
            let authOptins:UNAuthorizationOptions = [.alert,.badge,.sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptins, completionHandler: { _,_  in})
        }else{
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
        let userInfo = notification.request.content.userInfo
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        let title = notification.request.content.title
        if  title == "Disconnect"{
            let actualController = (appContainer.router.window?.rootViewController as? UINavigationController)?.visibleViewController
            if let selectview = actualController as? SelectRoleView{
                // change condition
                selectview.viewModel.otherDeviceDidUnpair()
            }else if let parentView = actualController as? ParentView{
                // automatically go back and show caution
                parentView.viewModel.otherDeviceDidUnpair()
            }else if let babyView = actualController as? ListenBabyView{
                // automatically go back and show caution
                babyView.viewModel.otherDeviceDidUnpair()
            }
        }else{
            UIApplication.shared.applicationIconBadgeNumber += 1
            completionHandler([[.banner, .sound]])
            // Change this to your preferred presentation option
        }
    }
}
extension AppDelegate:MessagingDelegate{
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        Messaging.messaging().token { token, _ in
            if let token = token {
                UserDefaults.standard.set(token, forKey: Cons.fcmToken)
            }
        }
    }
}




