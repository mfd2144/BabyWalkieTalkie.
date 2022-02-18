//
//  UserPageBuilder.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 26.07.2021.
//

import UIKit


final class SelectRoleBuilder{
    static func make()->UIViewController{
        let layout = UICollectionViewLayout()
        let view = SelectRoleView(collectionViewLayout: layout)
        let router = SelectRoleRouter()
        let viewModel = SelectRoleViewModel()
        let customMC = CustomMultipeerConnectivity()
        let service = FirebaseMatchService()
        let navController = UINavigationController(rootViewController: view)
        let productIds: Set<ProductIdentifier> = [PurchaseType.videoAudio.rawValue,
                                                  PurchaseType.video.rawValue,
                                                  PurchaseType.audio.rawValue]
        let iAPHelper = IAPHelper(productIds: productIds)
        view.viewModel = viewModel
        viewModel.productIds = productIds
        viewModel.iAPHelper = iAPHelper
        viewModel.delegate = view
        viewModel.router = router
        viewModel.matchService = service
        viewModel.customMC = customMC
        customMC.matchService = service
        router.view = view
        iAPHelper.delegate = viewModel
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .crossDissolve
        return navController
    }
}
