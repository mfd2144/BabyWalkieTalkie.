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
        viewModel.service = appContainer.authService
        viewModel.delegate = view
        view.viewModel = viewModel
        return view
    }
}
