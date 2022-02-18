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
    func setAsWalkieTalkie()
    func testPressed()
    func speakPressed()
    func videoPressed()
    func returnToSelectPage()
    func closePressed()
    func otherDeviceDidUnpair()
}
enum ParentViewModelOutputs{
    case anyErrorOccurred(String)
    case isLoading(Bool)
    case babyDeviceConnect(Bool)
    case testResult(Bool,String?)
    case alreadyLogisAsParent
    case babyDeviceNotConnect
    case thereNotPairedDevice
    case listener(Bool)
    case otherDeviceDidUnpair
}
protocol ParentViewModelDelegate:AnyObject{
    func handleOutputs(outputs:ParentViewModelOutputs)
}
protocol ParetRouterProtocol:AnyObject{
    func toSelectView()
    func toVideo(channelID:String,token:String,messageService:AgoraMessageService)
}
