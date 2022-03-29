//
//  FirebaseSmartListenerService.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 16.08.2021.
//

import Foundation
import FirebaseFunctions
import os.log

enum FamilyMemberRole:String{
    case baby
    case parent
    case purchase
}


enum AgoraConditions{
    case video
    case audio
    case parentOffline
    case parentOnline
    case noConnection
}



final class FirebaseAgoraService{
    typealias stringResult = (Results<String>)->Void
    typealias conditionResult = (FirebaseResults<AgoraConditions?>)->Void
    var tokenGenerator:TokenGeneratorService!
    var function = Functions.functions()
    
    private let mutualChannelID = "mutualChannel"
    var role:FamilyMemberRole?
    var parentConnection:AgoraConditions = .parentOnline
    var dataType:AgoraConditions = .audio
    
    
    init(role:FamilyMemberRole) {
        self.role = role
    }
    
    deinit {
        UserDefaults.standard.removeObject(forKey:mutualChannelID)
    }
    
    public func fetchChannelID(completion:@escaping stringResult){
        function.httpsCallable("fetchChannelID").call { result,error in
            if let error = error {
                completion(.failure(error))
            }else{
                guard let data = result?.data as? NSDictionary, let channelID = data["result"] as? String else {return}
                completion(.success(channelID))
            }
        }
    }
    
    public func enterTheChannel(role:FamilyMemberRole){
        var data:Dictionary<String,String> = [:]
        if role == .baby{
            data = ["role":"baby"]
        }else{
            data = ["role":"parent"]
        }
        function.httpsCallable("enterTheChannel").call(data) {_,_ in}
    }
    
    public func decideAboutChannel(completion:@escaping (Results<String>)->Void) {
        function.httpsCallable("decideAboutChannel").call{result, error in
            if let error = error {
                completion(.failure(error))
            }else{
                let _result = (result?.data as? NSDictionary)?["result"] as? String
                completion(.success(_result))
            }
        }
    }
    
    public func exitTheChannel(role:FamilyMemberRole, completion:@escaping (Results<String>)->Void){
        function.httpsCallable("exitTheChannel").call(["role":role.rawValue]){result, error in
            if let error = error {
                completion(.failure(error))
            }else{
                let _result = (result?.data as? NSDictionary)?["result"] as? String
                completion(.success(_result))
            }
        }
    }
    
    
    func iAmCrying(){
        let timeString = Date.actualStringTime()
        let lan = Locale.current.languageCode ?? ""
        let data:NSDictionary = ["timeData":timeString,
                                 "language":lan]
        function.httpsCallable("babyIsCrying").call(data){_,_ in }
    }
}
