//
//  ParentContracts.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 18.08.2021.
//

import UIKit

protocol ParentViewModelProtocol:AnyObject{
    var delegate : ParentViewModelDelegate? {get set}
   func startEverything()
    func  testPressed()
    func speakPressed()
    func videoPressed()
    func returnSelect()

}

enum ParentViewModelOutputs{
    case anyErrorOccurred(String)
    case isLoading(Bool)
}

protocol ParentViewModelDelegate:AnyObject{
    func handleOutputs(outputs:ParentViewModelOutputs)
}

protocol ParetRouterProtocol:AnyObject{
    func toSelectView()
    func toVideo(channelID:String,token:String)
}



