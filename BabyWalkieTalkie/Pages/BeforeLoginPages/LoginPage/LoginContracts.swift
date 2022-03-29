//
//  LoginContracts.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 9.07.2021.
//

import UIKit
import  FirebaseAuth


protocol LoginViewModelProtocol:AnyObject{
    var delegate :LoginViewModelDelegate? {get set}
    func logIn(_ email:String,_ password:String)
    func forgetPassword(_ userName: String?)
    func fbButtonPressed()
    func appleButtonPressed()
    func singUp()
    func googlePressed()
}

enum LoginModelOutputs{
    case setLoading(Bool)
    case anyErrorOccurred(String)
    case verificationSent
    
}

protocol LoginViewModelDelegate:AnyObject{
    func handleModelOutputs(_ output:LoginModelOutputs)
}

enum LoginRoutes{
    case signUpPage
    case forgotPassword(String?)
    case toUserPage
}

protocol LoginRouterProtocol:AnyObject{
    func routeToPage(_ page: LoginRoutes)
    
}


