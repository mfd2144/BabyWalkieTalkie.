//
//  FirstPageViewModel.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 12.07.2021.
//

import Foundation

final class FirstPageViewModel:FirstPageViewModelProtocol{
    weak var delegate: FirstPageViewModelDelegate?
    var router:FirstPageRouterProtocol!
    
    func goToPage(_ page: FirstPageRoutes) {
        router.routeToPage(page)
    }
    
}
