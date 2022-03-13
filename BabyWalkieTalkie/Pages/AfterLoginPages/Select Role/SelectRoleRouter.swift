//
//  UserPageRouter.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 29.07.2021.
//

import Foundation


final class SelectRoleRouter:SelectRoleRouterProtocol{
    var view:SelectRoleView!

    
    func routeToPage(_ route: SelectRoleRoutes) {
        switch route {
        case.toListenBaby:
            let listenBabyView = ListenBabyBuilder.make()
            view.present(listenBabyView, animated: false)
        case .toParentControl(let videoCondition):
            let parent = ParentBuilder.make(videoCondition)
            view.present(parent, animated: true, completion: nil)
        case .toPurchaseTable(let helper):
            let iAPTable = IAPTableBuilder.make(iAPHelper: helper)
            view.present(iAPTable, animated: true, completion: nil)
        }
    }
}
