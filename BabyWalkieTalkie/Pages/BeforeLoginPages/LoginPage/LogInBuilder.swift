//
//  LogInBuilder.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 12.07.2021.
//

import UIKit


final class LogInBuilder{
    static func make()->UIViewController{
        let service = FirebaseAuthenticationService()
        let loginView = LoginView()
        let model = LoginViewModel()
        let router = LoginRouter()
        loginView.model = model
        model.service = service
        model.delegate = loginView
        model.router = router
        router.view = loginView
        return loginView
    }
}


