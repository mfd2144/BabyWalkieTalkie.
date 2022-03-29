//
//  SceneDelegate.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 8.08.2021.
//

import UIKit
import FBSDKCoreKit
import Firebase
import GoogleSignIn

    class SceneDelegate: UIResponder, UIWindowSceneDelegate {
        var window: UIWindow?

        func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            guard let scene = (scene as? UIWindowScene) else { return }
            // decide opening condition
            appContainer.router.isUserLoginOrNot(scene)
        }
        
        func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
            guard let url = URLContexts.first?.url else {
                return
            }
            GIDSignIn.sharedInstance.handle(url)
            ApplicationDelegate.shared.application(
                UIApplication.shared,
                open: url,
                sourceApplication: nil,
                annotation: [UIApplication.OpenURLOptionsKey.annotation]
            )
        }

        func sceneDidDisconnect(_ scene: UIScene) {
            let actualController = (appContainer.router.window?.rootViewController as? UINavigationController)?.visibleViewController
            if let _ = actualController as? ListenBabyView{
                appContainer.authService.babyDeviceDisconnect()
            }else if let _ = actualController as? ParentView{
                appContainer.authService.parentDeviceDisconnect()
            }
            }
     
        func sceneWillResignActive(_ scene: UIScene) {
            // Called when the scene will move from an active state to an inactive state.
            // This may occur due to temporary interruptions (ex. an incoming phone call).
        }

      
        
    }


