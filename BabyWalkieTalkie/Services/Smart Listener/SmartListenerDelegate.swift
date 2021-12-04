//
//  SmartListenerContracts.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 21.08.2021.
//

import Foundation


protocol SmartListenerDelegate:AnyObject{
    func thereIsSoundAround()
    func setSoundLevel()->Float
}

protocol SmartListenerProtocol:AnyObject{
    func deleteAllTimer()
    func stopToListen()
    func startToListen()
}
