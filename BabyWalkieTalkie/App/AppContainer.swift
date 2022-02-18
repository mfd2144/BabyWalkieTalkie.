//
//  AppContainer.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 9.07.2021.
//

import Foundation
import UIKit

//MARK: - App Constants
let appContainer = AppContainer()
let buttonSize:CGFloat =  UIScreen.main.bounds.height >= 700.0 ? 50 : 40
let buttonDistance = buttonSize/2

final class AppContainer{
    let router = AppRouter()
    let authService = FirebaseAuthenticationService()
}
