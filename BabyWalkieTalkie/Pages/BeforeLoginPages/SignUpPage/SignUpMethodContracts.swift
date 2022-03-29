//
//  SignUpMethodPage.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 12.07.2021.
//

import Foundation



protocol SignUpMethodViewModelProtocol:AnyObject{
    var delegate:SignUpMethodViewModelDelegate? {get set}
    func signUp(_ user: UserInfo)
}

enum SignUpMethodViewModelOutputs:Equatable{
    case showAnyAlert(String)
    case isLoading(Bool)
    case signUpCompleted
}

protocol SignUpMethodViewModelDelegate:AnyObject{
   func handleOutput(_ output:SignUpMethodViewModelOutputs)
}

