//
//  LoginViewModel.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 9.07.2021.
//

import Foundation
import Firebase
import GoogleSignIn

final class LoginViewModel: LoginViewModelProtocol{
    
    var service: FirebaseAuthenticationService!
    weak var delegate: LoginViewModelDelegate?
    var router :LoginRouterProtocol!
    var googleProvider:GoogleProvider?
    var fbhelper:FBLoginHelper?
    var appleSingIn:AppleSignIn?
    
    func logIn(_ email: String, _ password: String) {
        delegate?.handleModelOutputs(.setLoading(true))
        //Check password and email is empty
        if email == "" || password == ""{
            delegate?.handleModelOutputs(.setLoading(false))
            delegate?.handleModelOutputs(.anyErrorOccurred(GeneralErrors.emptyFieldError.description))
            return
        }
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
        service.signIn(email: trimmedEmail, Password: password) {[weak self] result in
            guard let self = self else {return}
            self.delegate?.handleModelOutputs(.setLoading(false))
            switch result{
            case.failure(let error):
                self.delegate?.handleModelOutputs(.anyErrorOccurred(error.description))
            case.success(let stringResult):
                if let stringResult = stringResult as? String {
                    if stringResult == "verificationSend"{
                        self.delegate?.handleModelOutputs(.verificationSent)
                    }
                }else{
                    self.router.routeToPage(.toUserPage)
                }
            }
        }
    }
    
    func forgetPassword(_ userName: String?) {
        router.routeToPage(.forgotPassword(userName))
    }
    
    func singUp() {
        router.routeToPage(.signUpPage)
    }
    
    func fbButtonPressed() {
        delegate?.handleModelOutputs(.setLoading(true))
        fbhelper = FBLoginHelper()
        fbhelper?.delegate = self
        fbhelper?.login()
    }
    
    func googlePressed(){
        guard let loginView = delegate as? LoginView else {return}
        delegate?.handleModelOutputs(.setLoading(true))
        googleProvider = GoogleProvider(loginView)
        googleProvider?.delegate = self
        
    }
    
    func appleButtonPressed() {
        appleSingIn = AppleSignIn()
        appleSingIn?.delegate = self
    }
}

extension LoginViewModel:GoogleProviderDelegate{
    func googleSignInDidFail(_ errorString: String) {
        delegate?.handleModelOutputs(.setLoading(false))
        delegate?.handleModelOutputs(.anyErrorOccurred(errorString))
    }
    
    func googleSignInAccomplish() {
        delegate?.handleModelOutputs(.setLoading(false))
        router.routeToPage(.toUserPage)
    }
}

extension LoginViewModel:FBLoginDelegate{
    func cancelled() {
        delegate?.handleModelOutputs(.setLoading(false))
    }
    
    func success(name: String, email: String) {
        service.loginWithFB {[unowned self] results in
            delegate?.handleModelOutputs(.setLoading(false))
            switch results{
            case.success:
                router.routeToPage(.toUserPage)
            case .failure(let error):
                delegate?.handleModelOutputs(.anyErrorOccurred(error.description))
            }
        }
    }
    
    func error() {
        delegate?.handleModelOutputs(.setLoading(false))
        let fbErrorString = Local.faceError
        delegate?.handleModelOutputs(.anyErrorOccurred(fbErrorString))
    }
}

extension LoginViewModel:AppleSignInDelegate{
    func appleSignInAccomplish() {
        router.routeToPage(.toUserPage)
    }
    
    func appleSignInError(error: String) {
        delegate?.handleModelOutputs(.setLoading(false))
        delegate?.handleModelOutputs(.anyErrorOccurred(error))
    }
}

