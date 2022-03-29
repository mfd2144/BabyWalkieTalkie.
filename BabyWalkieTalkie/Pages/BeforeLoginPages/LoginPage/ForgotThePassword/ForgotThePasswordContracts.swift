//
//  ForgotThePasswordContracts.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 19.07.2021.
//

import Foundation


protocol ForgotThePasswordViewModelProtocol:AnyObject{
    var delegate: ForgotThePasswordViewModelDelegate? {get set}
    func fbButtonPressed()
    func googlePressed()
    func sendPasswordReset(email:String)
    func appleButtonPressed()
}

enum ForgotThePasswordViewModelOutputs{
    case isLoading(Bool)
    case loggedIn(Results<Any>)
    case showAnyAlert(String)
    case verificationCodeSend
}

protocol ForgotThePasswordViewModelDelegate:AnyObject{
    func handleOutput(_ output:ForgotThePasswordViewModelOutputs)
}

enum ForgotThePasswordViewModelRoutes{
    case toUserPage
    
}

protocol ForgotThePasswordRouterProtocol:AnyObject{
    func routeToPage(_ route: ForgotThePasswordViewModelRoutes)
}
