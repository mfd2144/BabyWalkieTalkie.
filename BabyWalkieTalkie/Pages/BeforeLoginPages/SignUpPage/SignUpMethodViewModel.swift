//
//  SignUpMethodPageViewModel.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 12.07.2021.
//

import Foundation

final class SignUpMethodViewModel:SignUpMethodViewModelProtocol{
    weak var delegate: SignUpMethodViewModelDelegate?
    var router: SignUpMethodRouterProtocol!
    var service:FirebaseAuthenticationService!
    
    func signUp(_ user: UserInfo) {
        guard let mail = user.mail,isValidEmail(mail) else {delegate?.handleOutput(.showAnyAlert(Local.invalidEmail));return}
        guard let password = user.password, checkPassword(password: password) else{delegate?.handleOutput(.showAnyAlert(Local.invalidPassword));return}
        guard user.userName != "" else {delegate?.handleOutput(.showAnyAlert(Local.emptyField));return}
        delegate?.handleOutput(.isLoading(true))
        service.createNewUserWithEmail(userInfos: user) {[unowned self] result in
            delegate?.handleOutput(.isLoading(false))
            switch result{
            case.success:
                router.routeToPage(.toUserPage)
            case.failure(let error):
                let errorDescription = Local.error + error.description
                delegate?.handleOutput(.showAnyAlert(errorDescription))
            }
        }
        
    }
    
    private func checkPassword(password:String)->Bool{
        guard password.count > 5 else {return false}
        var logicLetter = false
        var logicNumber = false
        
        password.forEach({ char in
            if char.isWholeNumber{
                logicNumber = true
            }else if char.isLetter{
                logicLetter = true
            }
        })
        guard logicLetter,logicNumber else {return false}
        return true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    

}



