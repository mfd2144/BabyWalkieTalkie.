//
//  ListenBabyContracts.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 12.08.2021.
//

import Foundation

protocol ListenBabyViewModelProtocol:AnyObject{
    var delegate:ListenBabyViewModelDelegate? {get set}
    var soundLevel:Float{get set}
    func startBroadcast(_ channel:String)
    func stopAudio()
    func startAudio()
    func startVideo()
    func stopVideo()
    func returnToSelectPage()
    func closePressed()
    func setPrecision(_ soundTreshold: Float)
}

enum ListenBabyViewModelOutputs{
    case anyErrorOccurred(String)
    case isLoading(Bool)
    case soundComing(Bool)
    case connected
    case alreadyLogisAsBaby
}

protocol ListenBabyViewModelDelegate:AnyObject{
    func handleOutputs(_ outputs:ListenBabyViewModelOutputs)
}

protocol ListenBabyRouterProtocol:AnyObject{
    func routeTo(_ page:ListenBabyRoutes)
}

enum ListenBabyRoutes{
    case toSelectPage
}


