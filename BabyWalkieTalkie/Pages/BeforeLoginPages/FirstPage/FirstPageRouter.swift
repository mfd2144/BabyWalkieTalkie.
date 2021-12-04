//
//  FirstPageRouter.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 12.07.2021.
//

import UIKit


final class FirstPageRouter:FirstPageRouterProtocol{
    
    unowned var view:FirstPageView!
    
    func routeToPage(_ page: FirstPageRoutes) {
        var newView:UIViewController?
        switch page {
        case .createNewUserPage:
            newView = SignUpMethodBuilder.make()
            
        case .logIn:
            newView = LogInBuilder.make()
        }
        guard let newView = newView else {return}
        view.navigationController?.pushViewController(newView, animated: true)    }
 
}
