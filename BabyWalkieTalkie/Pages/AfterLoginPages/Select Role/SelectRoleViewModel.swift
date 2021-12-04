//
//  2.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 17.08.2021.
//

import Foundation
import UIKit

final class SelectRoleViewModel:NSObject,SelectRoleViewModelProtocol{
    //MARK: - Variables
    weak var delegate: SelectRoleViewModelDelegate?
    var router:SelectRoleRouter!
    var iAPHelper: IAPHelper!
    var productIds: Set<ProductIdentifier>!
    var connectionStatus:Bool?
    var iAPCondition:IAPCondition?{
        didSet{
            delegate?.handleOutputs(.isLoading(false))
        }
    }
    
    var customMC:CustomMCProtocol!{
        didSet{
            customMC.delegate = self
        }
    }
    
    
    var connectionType:ConnectionType!
    var matchService: FirebaseMatchService!{
        didSet{
            matchService.checkmatchStatus(){ [unowned self] actualStatus in
                switch actualStatus{
                case.connected:
                    delegate?.handleOutputs(.matchStatus(.connected))
                case.error:
                    delegate?.handleOutputs(.matchStatus(.error))
                case.readyToConnect:
                    delegate?.handleOutputs(.matchStatus(.readyToConnect))
                default:
                    fatalError()
                }
                
            }
        }
    }
    
    override init() {
        super.init()
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(statusManager),
                         name: .flagsChanged,
                         object: nil)
        
#if targetEnvironment(simulator)
        connectionStatus = true
#else
        connectionStatus = Network.reachability.status == .unreachable ? false : true
#endif
        
    }
    
//MARK: - Reachability
@objc private func statusManager(_ notification: Notification) {
    updateConnectionStatus()
}


private func updateConnectionStatus(){
    switch Network.reachability.status{
    case.unreachable:
        connectionStatus = false
    case.wifi,.wwan:
        connectionStatus = true
    }
}

//MARK: - Multipeer Connectivty
func openConnection() {
    //connectionstatus check
    guard let status = connectionStatus, status else  {delegate?.handleOutputs(.badConnection);return}
    connectionType = .transmitter
    customMC.inviteUser()
}

func searchForConnection() {
    //connectionstatus check
    guard let status = connectionStatus, status else  {delegate?.handleOutputs(.badConnection);return}
    connectionType = .receiver
    customMC.searchUser()
}

func disconnetRequest() {
    guard let status = connectionStatus, status else  {delegate?.handleOutputs(.badConnection);return}
    delegate?.handleOutputs(.isLoading(true))
    matchService.disconnetUsers { [unowned self] results in
        delegate?.handleOutputs(.isLoading(false))
        switch results{
        case .failure(let error):
            delegate?.handleOutputs(.showAnyAlert(error.localizedDescription))
        case.success:
            delegate?.handleOutputs(.matchStatus(.readyToConnect))
        }
    }
}

//MARK: - Routes
func toParentControl() {
    //first check connection-done
    guard let status = connectionStatus, status else  {delegate?.handleOutputs(.badConnection);return}
    guard iAPCondition != .finished && iAPCondition != nil else {delegate?.handleOutputs(.membershipCaution);return}
    router.routeToPage(.toParentControl)
}

func toListenBaby() {
    // first check connection
    guard let status = connectionStatus, status else  {delegate?.handleOutputs(.badConnection);return}
    router.routeToPage(.toListenBaby)
}

func toPurchase() {
    router.routeToPage(.toPurchaseTable(helper: iAPHelper))
}


}

extension SelectRoleViewModel:CustomMCDelegate{
    func decideToInvitation(by invitionOwner: String, completionHandler: (Bool) -> ()) {
        guard let result = delegate?.invitationArrived(by: invitionOwner) else {return}
        completionHandler(result)
    }
    
    
    
    func requestError(_ error: Error) {
        
    }
    
    func showNearbyDevice(_ peerName: String) {
        delegate?.handleOutputs(.showNearbyUser(peerName))
    }
    
    func connectionStatus(_ status: Status) {
        if status == .paired && connectionType == .transmitter{
            customMC.sendRequest(){ result in
            }
        }
        if status == .paired{
            delegate?.handleOutputs(.matchStatus(.connected))
        }else if status == .connecting{
            delegate?.handleOutputs(.matchStatus(.loading))
        }
        
    }
}
extension SelectRoleViewModel{
    
    //MARK: - Purchase
    private func checkPuchaseCondition(completion:@escaping(Bool,PurchaseType?)->Void){
        if iAPHelper.isProductPurchased(ProductIdentifier.init(PurchaseType.audio.rawValue)){
            completion(true,.audio)
        }else if iAPHelper.isProductPurchased(ProductIdentifier.init(PurchaseType.videoAudio.rawValue)){
            completion(true,.videoAudio)
        }else{
            completion(false,nil)
        }
    }
    
    //MARK: - Demo Check
    func checkDemo(){
        guard let status = connectionStatus, status else  {delegate?.handleOutputs(.badConnection);return}
        delegate?.handleOutputs(.isLoading(true))
        checkPuchaseCondition{[unowned self] purchaseResult,purchaseType in
            switch purchaseResult{
            case true:
                guard let purchaseType = purchaseType else {return}
                iAPCondition = .aleadyMember(purchaseType)
//                delegate?.handleOutputs(.purchasedBefore(purchaseType))
            case false:
                checkRemainingDemo()
            }
        }
    }
    
    
    private func checkRemainingDemo(){
        matchService.fetchRegisterDate {[unowned self] result in
            switch result{
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let dateString):
                //                let testDate = "Sat Nov 20 2021 17:12:10 GMT+0000 (Coordinated Universal Time)"
                guard let dateString = dateString else{return}
                let dateFormat = "E MMM dd yyyy HH:mm:ss Z"
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = dateFormat
                dateFormatter.timeZone = TimeZone(identifier: "UTC")
                let trimmedIsoDate = dateString.replacingOccurrences(of: "GMT([+-]\\d{4})\\s\\([^)]+\\)", with: "$1", options: .regularExpression)
                
                guard let registerDate = dateFormatter.date(from: trimmedIsoDate),
                      let oneDayAfter = Calendar.current.date(byAdding: .day, value: 1, to: registerDate),
                      let twoDayAfter:Date = Calendar.current.date(byAdding: .day, value: 2, to: registerDate),
                      let threeDayAfter = Calendar.current.date(byAdding: .day, value: 3, to: registerDate) else {return}
                
                let now = Date()
                
                let firstComp = now.compare(oneDayAfter)
                let secondComp = now.compare(twoDayAfter)
                let thirdComp = now.compare(threeDayAfter)
                
                switch thirdComp{
                case.orderedDescending:
                    //Finished
                    iAPCondition = .finished
                    delegate?.handleOutputs(.remainingDay(.finished))
                default:
                    switch secondComp{
                    case.orderedDescending:
                        //1 day remaning
                        iAPCondition = .oneDay
                        delegate?.handleOutputs(.remainingDay(.oneDay))
                    default:
                        switch firstComp{
                        case .orderedDescending:
                            //2 days remaning
                            iAPCondition = .twoDays
                            delegate?.handleOutputs(.remainingDay(.twoDays))
                        case.orderedAscending,.orderedSame:
                            //3 days
                            iAPCondition = .threeDays
                            delegate?.handleOutputs(.remainingDay(.threeDays))
                        }
                    }
                }
            }
        }
    }
}


