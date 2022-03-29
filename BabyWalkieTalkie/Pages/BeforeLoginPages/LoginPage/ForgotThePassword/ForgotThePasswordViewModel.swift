//
//  ForgotThePasswordViewModel.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 19.07.2021.
//

import Foundation
import GoogleSignIn

final class ForgotThePasswordViewModel:ForgotThePasswordViewModelProtocol{
   weak var delegate: ForgotThePasswordViewModelDelegate?
    var router : ForgotThePasswordRouterProtocol!
    var authService: FirebaseAuthenticationService!
    var googleProvider:GoogleProvider?
    var fbhelper:FBLoginHelper!
    var appleSingIn:AppleSignIn!
    
    func googlePressed(){
        guard let forgotPasswordView = delegate as? ForgotThePasswordView else {return}
        delegate?.handleOutput(.isLoading(true))
        googleProvider = GoogleProvider(forgotPasswordView)
        googleProvider?.delegate = self
    }

    
    func fbButtonPressed() {
        delegate?.handleOutput(.isLoading(true))
        fbhelper = FBLoginHelper()
        fbhelper?.delegate = self
        fbhelper?.login()
    }
    
    func sendPasswordReset(email:String){
        guard isValidEmail(email) else {return}
        authService.sendEmailPasswordReset(email: email) {[unowned self] result in
            switch result{
            case.failure(let error):
                delegate?.handleOutput(.showAnyAlert(error.description))
            case .success:
                delegate?.handleOutput(.verificationCodeSend)
            }
        }
    }
    
    func appleButtonPressed() {
        appleSingIn = AppleSignIn()
        appleSingIn?.delegate = self
    }
    
}
    
//MARK: - Google
extension ForgotThePasswordViewModel:GoogleProviderDelegate{
    func googleSignInDidFail(_ errorString: String) {
        delegate?.handleOutput(.isLoading(false))
        delegate?.handleOutput(.showAnyAlert(errorString))
    }
    
    func googleSignInAccomplish() {
        delegate?.handleOutput(.isLoading(true))
        router.routeToPage(.toUserPage)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

//MARK: - Facebook

extension ForgotThePasswordViewModel:FBLoginDelegate{
    func cancelled() {
        delegate?.handleOutput(.isLoading(false))
    }
    
    func success(name: String, email: String) {
        authService.loginWithFB {[unowned self] results in
            delegate?.handleOutput(.isLoading(false))
            switch results{
            case.success:
                router.routeToPage(.toUserPage)
            case .failure(let error):
                delegate?.handleOutput(.loggedIn(.failure(error)))
            }
        }
    }
    
    func error() {
        delegate?.handleOutput(.isLoading(false))
        let fbErrorString = Local.faceError
        delegate?.handleOutput(.showAnyAlert(fbErrorString))
    }
}

extension ForgotThePasswordViewModel:AppleSignInDelegate {
    func appleSignInAccomplish() {
        router.routeToPage(.toUserPage)

    }
    
    func appleSignInError(error: String) {
        delegate?.handleOutput(.isLoading(false))
        delegate?.handleOutput(.showAnyAlert(error))
    }
    
    
}
    
    
    

    
    





