//
//  IAHelperDelegate.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 28.02.2022.
//

import Foundation

protocol IAPHelperDelegate:AnyObject{
    func loadProduct()
    func busy()
    func throwError(error:String)
}
