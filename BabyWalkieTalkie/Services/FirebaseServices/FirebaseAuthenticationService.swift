//
//  FirebaseAuthenticationService.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 16.07.2021.
//

import Foundation
import FirebaseAuth
import FBSDKLoginKit
import FirebaseFunctions
import os.log




final class FirebaseAuthenticationService{
    typealias result = (FirebaseResults<Any?>)->Void
    typealias stringResult = (FirebaseResults<String?>)->Void
    lazy var functions = Functions.functions()
    
    
    public func signIn(email:String,Password:String,completion: @escaping result){
        Auth.auth().signIn(withEmail: email, password: Password) { authResult, error in
            if let error = error{
                completion(.failure(.errorContainer(error.localizedDescription)))
            }else{
                if let authResult = authResult {
                    let user = authResult.user
                    if user.isEmailVerified {
                        completion(.success(nil))
                    } else {
                        user.sendEmailVerification { error in
                            if let error = error{
                                completion(.failure(.verificationError(error.localizedDescription)))
                            }else{
                                completion(.success("verificationSend"))
                            }
                            
                        }
                    }
                  }
            }
        }
    }
    
        
    public func createNewUserWithEmail(userInfos:UserInfo,completion:@escaping result){
        guard let password = userInfos.password,
              let _ = userInfos.userName,
              let mail = userInfos.mail else { return }
        Auth.auth().createUser(withEmail: mail, password: password) {authDataResult, error in
            if let error = error{
                completion(.failure(.errorContainer(error.localizedDescription)))
            }else{
                let changeRequest = authDataResult?.user.createProfileChangeRequest()
                changeRequest?.displayName = userInfos.userName
                changeRequest?.commitChanges(completion: { [unowned self] error in
                    if let error = error{
                        completion(.failure(.errorContainer(error.localizedDescription)))
                    }else{
                        let data = ["userName":userInfos.userName,
                                    "email":userInfos.mail]
                        functions.httpsCallable("saveUserToDB").call(data) { _, error in
                            if let error = error{
                                completion(.failure(.errorContainer(error.localizedDescription)))
                            }else{
                                authDataResult?.user.sendEmailVerification(completion: {_ in })
                                completion(.success(nil))
                            }
                        }
                        
                    }
                })
                
            }
        }
        
    }
    
    
    //MARK: - Facebook login
    
    public func loginWithFB(completion:@escaping result){
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        Auth.auth().signIn(with: credential) { [unowned self]authResult, error in
            if let error = error {
                completion(.failure(.errorContainer(error.localizedDescription)))
            }else{
                guard let providerData = authResult?.user.providerData else {completion(.failure(.providerError)); return}
                var email: String!
                for firUserInfo in providerData {
                    email =  firUserInfo.email
                }
                guard let mail = email,
                      let name = authResult?.user.displayName
                else {return}
                
                let data = ["userName":name,
                            "email":mail]
                functions.httpsCallable("saveUserToDB").call(data) { _, error in
                    if let error = error{
                        completion(.failure(.errorContainer(error.localizedDescription)))
                    }else{
                        completion(.success(nil))
                    }
                }
            }
        }
    }
    
    //MARK: - Login with google
    
    public func loginWithGoogle(_ credential:AuthCredential ,completion:@escaping result){
        Auth.auth().signIn(with: credential) { [unowned self]authResult, error in
            if let error = error {
                completion(.failure(.errorContainer(error.localizedDescription)))
            }else{
                guard let providerData = authResult?.user.providerData else {return}
                var email: String!
                for firUserInfo in providerData {
                    email =  firUserInfo.email
                }
                
                
                guard let mail = email,
                      let name = authResult?.user.displayName
                else {return}
                
                let data = ["userName":name,
                            "email":mail]
                functions.httpsCallable("saveUserToDB").call(data) { _, error in
                    if let error = error{
                        completion(.failure(.errorContainer(error.localizedDescription)))
                    }else{
                        completion(.success(nil))
                    }
                }
            }
        }
    }
    
    func loginWithApple(_ credential:OAuthCredential, name:String?, mail:String? ,completion:@escaping result){
        Auth.auth().signIn(with: credential) { [unowned self]authResult, error in
            if let error = error {
                completion(.failure(.errorContainer(error.localizedDescription)))
            }else{
                let data = ["userName":name,
                            "email":mail]
                functions.httpsCallable("saveUserToDB").call(data) { response, error in
                    Animator.sharedInstance.hideAnimation()
                    if let error = error{
                        completion(.failure(.errorContainer(error.localizedDescription)))
                    }else{
                        let result = (response?.data as? NSDictionary)?["result"] as? String
                        if result == "error"{
                            completion(.failure(.errorContainer(FirebaseLocal.tryOtherWay)))
                        }else{
                            completion(.success(nil))
                        }
                       
                    }
                }
            }
        }
    }
    //MARK: - Fetch agora app id
    func fetchAppID(){
        functions.httpsCallable("fetchAgoraAppID").call {result, error in
            if error != nil {
                os_log("fetching ID error",log: OSLog.viewCycle, type: .error)
            }else{
                let appID = (result?.data as? NSDictionary)?["appID"] as? String
                AppSingleton.sharedInstance.appID = appID
            }
        }
    }
    
    //MARK: -Reset email link
    
    public func sendEmailPasswordReset(email:String,completion:@escaping result){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error{
                completion(.failure(.errorContainer(error.localizedDescription)))
            }else{
                completion(.success(nil))
            }
        }
    }
    
    //MARK: - Login log out Methods
    public func signOut(){
        defer {
            do{
                try Auth.auth().signOut()
            }catch{
                
            }
        }
        guard let fcmToken = UserDefaults.standard.string(forKey: Cons.fcmToken) else {return}
        let data :Dictionary<String,String> = ["fcm":fcmToken]
        functions.httpsCallable("removeFCM").call(data) { _, _ in }
    }
    
    func getUserdNameAndId()->ShortUserPresentation?{
        guard let user = Auth.auth().currentUser else {return nil}
        //todo
        return ShortUserPresentation(name: user.displayName ?? "boş", ID: user.uid)
    }
    
    func checkFCM(){
        guard let fcmToken = UserDefaults.standard.string(forKey: Cons.fcmToken) else {return}
        let data :Dictionary<String,String> = ["fcm":fcmToken]
        functions.httpsCallable("checkFCM").call(data) { _,_ in  }
    }
    
    func babyDeviceDisconnect(){
        let data = ["language":Locale.current.languageCode ?? ""]
        functions.httpsCallable("babyDeviceDisconnect").call(data){_,_ in }
    }
    
    func parentDeviceDisconnect(){
        functions.httpsCallable("parentDeviceDisconnect").call{_,_ in }
    }
}

