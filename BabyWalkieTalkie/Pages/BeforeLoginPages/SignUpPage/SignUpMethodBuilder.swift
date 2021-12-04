//
//  SignUpMethodPageBuilder.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 12.07.2021.
//

import UIKit

final class SignUpMethodBuilder{
    static func make()->UIViewController{
        let view = SignUpMethodView()
        let viewModel = SignUpMethodViewModel()
        let router = SignUpMethodRouter()

        

        viewModel.service = appContainer.authService
        viewModel.router = router
        viewModel.delegate = view
        view.viewModel = viewModel
        router.view = view
        
        return view
    }
}
