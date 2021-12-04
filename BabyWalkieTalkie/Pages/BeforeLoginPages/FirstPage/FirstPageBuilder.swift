//
//  FisrtPageBuilder.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 12.07.2021.
//

import UIKit

final class FirstPageBuilder{
    static func make()->UIViewController{
        let firstPageView = FirstPageView()
        let router = FirstPageRouter()
        let viewModel = FirstPageViewModel()
        viewModel.router = router
        viewModel.delegate = firstPageView
        firstPageView.model = viewModel
        router.view = firstPageView
        return firstPageView
    }
}


