//
//  FirebaseMatchService.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 29.08.2021.
//

import Foundation
import FirebaseFunctions

class FirebaseMatchService{
    lazy var function = Functions.functions()
    typealias stringResult = (Results<String>)->Void
    
    func checkmatchStatus(completion:@escaping (MatchStatus)->Void){
        function.httpsCallable("checkConnectionStatus").call { response, error in
            if error != nil {
                completion(.error)
            }else{
                guard let _result = response?.data as? Dictionary<String,Bool> ,let result = _result.first?.value else {return completion(.error)}
                result ? completion(.connected) : completion(.readyToConnect)
            }
        }
    }
    
    
    func saveChannelToUser(channelID:String
                           ,partnerID:String
                           ,completion:@escaping stringResult) {
        guard let deviceToken =  UserDefaults.standard.string(forKey: Cons.fcmToken) else {return}
        
        let data:Dictionary<String,String> = ["channelID":channelID,
                    "partnerID":partnerID,
                    "deviceToken":deviceToken]
        
        function.httpsCallable("saveChannelToUser").call(data){ result, error in
            if let error = error {
                completion(.failure(error))
            }else{
                guard let resultData = result?.data as? NSDictionary, let response = resultData["result"] as? String else {return}
                completion(.success(response))
                
            }
        }
    }
    func disconnetUsers(completion:@escaping stringResult){
        function.httpsCallable("killTheChannel").call { response,error in
            if let error = error{
                completion(.failure(error))
            }else{
                completion(.success(nil))
            }
            
        }
        
    }
    
    func fetchRegisterDate(completion:@escaping stringResult){
        function.httpsCallable("fetchRegisterDate").call{ dateResult,error in
            if let error = error{
                completion(.failure(error))
            }else{
                if let stringDate = (dateResult?.data as? [String: Any])?["result"] as? String {
                    completion(.success(stringDate))
                }
            }
           
        }
    }
}

