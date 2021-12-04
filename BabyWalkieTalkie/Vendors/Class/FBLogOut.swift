//
//  FBLogOut.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 19.07.2021.
//

import FBSDKLoginKit


final class FBLogOut{
    static let sharedInstance = FBLogOut()
    private let manager = LoginManager()
    private init(){
        
    }
    func logOut(){
        manager.logOut()
    }
}

