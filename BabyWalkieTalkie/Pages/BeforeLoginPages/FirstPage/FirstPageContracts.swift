//
//  FirstPageContracts.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 12.07.2021.
//

import UIKit


protocol FirstPageRouterProtocol:AnyObject{
    func routeToPage(_ page:FirstPageRoutes)
}

enum FirstPageRoutes{
    case logIn
    case createNewUserPage
}

protocol FirstPageViewModelProtocol:AnyObject{
    var delegate:FirstPageViewModelDelegate? {get set}
    func goToPage(_ page:FirstPageRoutes)
}

protocol FirstPageViewModelDelegate:AnyObject{

}
