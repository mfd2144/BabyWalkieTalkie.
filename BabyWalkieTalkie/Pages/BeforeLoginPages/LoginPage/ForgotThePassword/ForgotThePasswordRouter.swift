//
//  Router.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 19.07.2021.
//

import Foundation
import UIKit

final class ForgotThePasswordRouter:ForgotThePasswordRouterProtocol{
    unowned var view:ForgotThePasswordView!
    
    func routeToPage(_ route: ForgotThePasswordViewModelRoutes) {
        switch route{
        case .toUserPage:
            appContainer.router.checkLogin()
        }
    }
    
  
    

    
    
}



