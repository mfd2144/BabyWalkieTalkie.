//
//  ParentBuilder.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 18.08.2021.
//

import class UIKit.UIViewController

final class ParentBuilder{
    static func make(_ videoCondition:Bool)->UIViewController{
        let view = ParentView()
        let viewModel = ParentViewModel()
        let firebaseAgoraService = FirebaseAgoraService(role: .parent)
        let tokenGeneratoService = TokenGeneratorService()
        let router = ParentRouter()
    
        router.view = view
        view.viewModel = viewModel
        viewModel.didVideoPurchased = videoCondition
        viewModel.delegate = view
        viewModel.router = router
        viewModel.firebaseService = firebaseAgoraService
        viewModel.tokenDelegate = tokenGeneratoService
        view.modalPresentationStyle = .fullScreen
        return view
    }
}
