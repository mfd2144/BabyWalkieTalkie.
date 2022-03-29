//
//  GlobalConstant.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 21.03.2022.
//

import UIKit

let appContainer = AppContainer()
let buttonSize:CGFloat =  UIScreen.main.bounds.height >= 700.0 ? 50 : 40
let buttonDistance = buttonSize/2
let personWillSaveToDbKey = "personWillSaveToDb"
var screenWidth:CGFloat{
    if UIDevice.current.orientation.isLandscape {
        return UIScreen.main.bounds.height
    } else {
        return UIScreen.main.bounds.width
    }
}
var screenHeight:CGFloat{
    if UIDevice.current.orientation.isLandscape {
        return UIScreen.main.bounds.width
    } else {
        return UIScreen.main.bounds.height
    }
}
