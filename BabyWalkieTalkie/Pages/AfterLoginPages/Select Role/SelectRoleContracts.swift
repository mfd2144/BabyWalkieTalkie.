//
//  UserPageContacts.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 22.07.2021.
//

import Foundation

protocol SelectRoleViewModelProtocol:AnyObject{
    var delegate: SelectRoleViewModelDelegate? {get set}
    func checkDidPairBefore()
    func checkDidConnetionLostBefore()
    func toParentControl()
    func toListenBaby()
    func openConnection()
    func searchForConnection()
    func disconnectRequest()
    func checkDemo()
    func toPurchase()
    func otherDeviceDidUnpair()
}

enum SelectRoleViewModelOutputs{
    case isLoading(Bool)
    case showAnyAlert(String)
    case showNearbyUser(String)
    case matchStatus(MatchStatus)
    case remainingDay(IAPCondition)
    case badConnection
    case membershipCaution
}

protocol SelectRoleViewModelDelegate:AnyObject {
    func handleOutputs(_ output: SelectRoleViewModelOutputs)
    func invitationArrived(by:String)->Bool
}


enum SelectRoleRoutes{
    case toParentControl
    case toListenBaby
    case toPurchaseTable(helper:IAPHelper)
}

protocol SelectRoleRouterProtocol:AnyObject{
    func routeToPage(_ route: SelectRoleRoutes)
}

enum MatchStatus{
    case connected
    case loading
    case readyToConnect
    case error
}

