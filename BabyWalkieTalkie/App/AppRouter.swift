
//  AppRouter.swift
//  Baby Walki Talkie
//  Created by Mehmet fatih DOĞAN on 9.07.2021.
//

import UIKit
import Firebase


final class AppRouter:NSObject{
    var window:UIWindow?
    var scene:UIWindowScene!
    override init() {
        super.init()
      
        NotificationCenter.default.addObserver(self, selector: #selector(userDidChangeStatus(_ :)), name: .AuthStateDidChange, object: nil)

    }

    func start(_ windowScene: UIWindowScene){
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        let navController = UINavigationController(rootViewController: FirstPageBuilder.make())
        navController.navigationBar.tintColor = MyColor.secondColor
        navController.navigationBar.isHidden = true
        window?.rootViewController = navController
        window?.makeKeyAndVisible()

    }
    
    func startAsLoggedIn(_ windowScene: UIWindowScene){
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        let selectView = SelectRoleBuilder.make()
        window?.rootViewController = selectView
        window?.makeKeyAndVisible()
        
        //Check FCM and rewrite db if it need to be saved
        appContainer.authService.checkFCM()
        
        // if there is a recorded user set db as online
//        appContainer.authService.setUserOnline()
    }

    func isUserLoginOrNot(_ windowScene: UIWindowScene){
       scene = windowScene
        if Auth.auth().currentUser != nil {
              startAsLoggedIn(windowScene)
        }else{
              start(windowScene)
        }
    }
    
    func checkLogin(){
        if Auth.auth().currentUser != nil {
              startAsLoggedIn(scene)
        }else{
              start(scene)
        }
    }
    
    func startAnyNewView(_ vc:UIViewController,navControlller:Bool){
        window = UIWindow(frame: scene.coordinateSpace.bounds)
        window?.windowScene = scene
        let view = navControlller ? UINavigationController(rootViewController: vc) : vc
        window?.rootViewController = view
        window?.makeKeyAndVisible()
    }
    
   
    @objc private func userDidChangeStatus(_ responder:NSNotification){
        //for some user's process app write user document ID to singleton
        DispatchQueue.main.async { [unowned self] in
            if Auth.auth().currentUser == nil {
                //logout
                  start(scene)
                FBLogOut.sharedInstance.logOut()
            }else{
                // login
                
            }
        }
    }

}






