//
//  ListenBabyRouter.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 20.08.2021.
//

import Foundation

final class ListenBabyRouter:ListenBabyRouterProtocol{
    unowned var view:ListenBabyView!
    func routeTo(_ page: ListenBabyRoutes) {
        switch page {
        case .toSelectPage:
            view.dismiss(animated: true)
        }
    }
}
