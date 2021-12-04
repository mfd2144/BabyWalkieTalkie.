//
//  SignUpMethodPageRouter.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 12.07.2021.
//

import Foundation

final class SignUpMethodRouter:SignUpMethodRouterProtocol{
    
        unowned var view:SignUpMethodView!
    
    
    func routeToPage(_ route: SingUpMethodRoutes) {
        switch route {
        case.toUserPage:
            appContainer.router.checkLogin()
        }
    }
    

}
