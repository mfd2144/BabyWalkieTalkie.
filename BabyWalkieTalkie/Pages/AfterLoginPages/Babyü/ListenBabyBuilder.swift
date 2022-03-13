//
//  ListenBabyBuilder.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 12.08.2021.
//

import class UIKit.UIViewController

final class ListenBabyBuilder{
    static func make()->UIViewController{
        let view = ListenBabyView()
        let viewModel = ListenBabyViewModel()
        let router = ListenBabyRouter()

        let firebaseService = FirebaseAgoraService(role: .baby)
        let tokenGeneratorService = TokenGeneratorService()
        let smartListener = SmartListener()
        
        viewModel.tokenDelegate = tokenGeneratorService
        viewModel.smartListenerProtocol = smartListener
        
        smartListener.delegate = viewModel
        view.viewModel = viewModel
        viewModel.delegate = view
        viewModel.firebaseService = firebaseService
        router.view = view
        viewModel.router = router
        view.modalPresentationStyle = .fullScreen
        return view
    }
}
