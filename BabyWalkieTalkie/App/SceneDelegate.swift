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
//            appContainer.authService.setUserOffline()
            
        }

        func sceneDidBecomeActive(_ scene: UIScene) {
            // Called when the scene has moved from an inactive state to an active state.
            // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        }

        func sceneWillResignActive(_ scene: UIScene) {
            // Called when the scene will move from an active state to an inactive state.
            // This may occur due to temporary interruptions (ex. an incoming phone call).
        }

        func sceneWillEnterForeground(_ scene: UIScene) {
            // Called as the scene transitions from the background to the foreground.
            // Use this method to undo the changes made on entering the background.
        }

        func sceneDidEnterBackground(_ scene: UIScene) {
            // Called as the scene transitions from the foreground to the background.
            // Use this method to save data, release shared resources, and store enough scene-specific state information
            // to restore the scene back to its current state.

            // Save changes in the application's managed object context when the application transitions to the background.
        }


    }


