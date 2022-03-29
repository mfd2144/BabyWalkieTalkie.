//
//  FBLoginHelper.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 4.11.2021.
//

import Foundation
import FBSDKLoginKit


protocol FBLoginDelegate:AnyObject{
    func cancelled()
    func success(name:String,email:String)
    func error()
}


final class FBLoginHelper:NSObject{
    let manager = LoginManager()
    weak var delegate:FBLoginDelegate?
    
    func login(){
        manager.logIn(permissions: [.publicProfile, .email ], viewController: nil) {[unowned self] (result) in
            switch result{
            case .cancelled:
                delegate?.cancelled()
            case .success:
                let params:[String:Any] = ["fields" : "id, name, first_name, last_name, picture.type(large), email "]
                let graphRequest = GraphRequest.init(graphPath: "/me", parameters: params)
                let Connection = GraphRequestConnection()
                Connection.add(graphRequest) {[unowned self]  (Connection, result, error) in
                    let info = result as! [String : AnyObject]
                    let name = info["name"] as! String
                    let mail = info["email"] as! String
                    delegate?.success(name: name, email: mail)
                }
            Connection.start()
            default:
                delegate?.error()
            }
        }
    }
}
