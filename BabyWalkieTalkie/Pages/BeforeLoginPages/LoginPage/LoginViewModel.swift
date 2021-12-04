//
//  LoginViewModel.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 9.07.2021.
//

import Foundation
import Firebase
import GoogleSignIn

final class LoginViewModel:LoginViewModelProtocol{
    
    var service: FirebaseAuthenticationService!
    weak var delegate: LoginViewModelDelegate?
    var router :LoginRouterProtocol!
    var googleProvider:GoogleProvider?
    var fbhelper:FBLoginHelper?
    
    
    func logIn(_ email: String, _ password: String) {
        delegate?.handleModelOutputs(.setLoading(true))
        //Check password and email is empty
        if email == "" || password == ""{
            delegate?.handleModelOutputs(.setLoading(false))
            delegate?.handleModelOutputs(.loggedIn(.failure(GeneralErrors.emptyFieldError)))
            return
        }
        
        service.signIn(email: email, Password: password) {[weak self] result in
            guard let self = self else {return}
            self.delegate?.handleModelOutputs(.setLoading(false))
            switch result{
            case.failure(let error):
                self.delegate?.handleModelOutputs(.loggedIn(.failure(error)))
            case.success:
                self.router.routeToPage(.toUserPage)
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
        googleProvider = GoogleProvider(loginView)
        googleProvider?.delegate = self
        
    }
    
}

extension LoginViewModel:GoogleProviderDelegate{
    func googleSignInDidFail(_ errorString: String) {
        delegate?.handleModelOutputs(.anyErrorOccurred(errorString))
    }
    
    func googleSignInAccomplish() {
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
                delegate?.handleModelOutputs(.loggedIn(.failure(error)))
            }
        }
    }
    
    func error() {
        delegate?.handleModelOutputs(.setLoading(false))
    }
    
    
}


