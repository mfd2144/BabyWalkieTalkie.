//
//  MultipeerConnectivty.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 1.09.2021.
//

import Foundation


import MultipeerConnectivity



class CustomMultipeerConnectivity:NSObject{
    //MARK: - Properties
    var advertiser: MCNearbyServiceAdvertiser?
    let serviceType = "MatchDevice"
    var myId = MCPeerID(displayName: UIDevice.current.name)
    var browser: MCNearbyServiceBrowser?
    var session: MCSession?
    var connectedPeer: MCPeerID?
    weak var delegate: CustomMCDelegate?
    var request:MatchingRequest!
    var channelID:String!
    var matchService: FirebaseMatchService!
    
    //MARK: - Functions
    
    func becomeAdvertiser() {
        stop()
        let discoveryInfo = [
            "Device Type": UIDevice.current.model,
            "OS": UIDevice.current.systemName,
            "OS Version": UIDevice.current.systemVersion
        ]
        
        advertiser = MCNearbyServiceAdvertiser(peer: myId, discoveryInfo: discoveryInfo, serviceType: serviceType)
        advertiser?.delegate = self
        advertiser?.startAdvertisingPeer()
    }
    
    func searchForDevices() {
        stop()
        browser = MCNearbyServiceBrowser(peer: myId, serviceType: serviceType)
        browser?.delegate = self
        browser?.startBrowsingForPeers()
    }
    
}

extension CustomMultipeerConnectivity:MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate{
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        if state == .connected && advertiser != nil{
            sendRequest { _ in
                
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let request = MatchingRequest.getPacketFromData(data: data) {
            delegate?.pairStatus(.connecting)
            if advertiser == nil {
                //user searching channel
                // data send by device which opening channel
                DispatchQueue.main.async { [unowned self] in
                    matchService = FirebaseMatchService()
                    let channelID = request.mutualChannel
                    let requestOwnerID = request.requestOwnerId
                    matchService.saveChannelToUser(channelID: channelID, partnerID: requestOwnerID){ result in
                        switch result{
                        case .failure(let error):
                            //todo maybe clear when sending process fail
                            printNew(error.localizedDescription)
                        case .success(let response):
                            sendRequest2(channelID: channelID) { sendingResult in
                                delegate?.pairStatus(.paired)
                                //todo maybe clear when sending process fail
                            }
                        }
                    }
                }
            }else{
                DispatchQueue.main.async { [unowned self] in
                    stop()
                    matchService = FirebaseMatchService()
                    let channelID = request.mutualChannel
                    let requestOwnerID = request.requestOwnerId
                    matchService.saveChannelToUser(channelID: channelID, partnerID: requestOwnerID){ result in
                        delegate?.pairStatus(.paired)
                    }
                }
            }
        }
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        delegate?.decideToInvitation(by: peerID.displayName, completionHandler: { userDecision in
            guard let context = context else { return }
            let id = IdentityData.getId(data: context)
            guard id?.sender == "receiver" else {return}
            if userDecision{
                session = MCSession(peer: myId)
                session?.delegate = self
                invitationHandler(true,session)
            }else{
                invitationHandler(false,nil)
            }
        })
    }
    
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        //search connection çalıştırdı
        delegate?.showNearbyDevice(peerID.displayName)
        invitePeerToConnect(peerID: peerID)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        stop()
    }
    
    func invitePeerToConnect(peerID: MCPeerID) {
        //search connection çalıştırıyor
        session = MCSession(peer: myId)
        session?.delegate = self
        self.connectedPeer = peerID
        let id = IdentityData.getData(id: IdentityData(sender: "receiver"))
        browser?.invitePeer(peerID, to: session!, withContext: id, timeout: 30)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
}

extension CustomMultipeerConnectivity:CustomMCProtocol{
    
    func inviteUser() {
        becomeAdvertiser()
    }
    
    func searchUser() {
        searchForDevices()
    }
    
    func stop() {
        advertiser?.stopAdvertisingPeer()
        session?.disconnect()
        advertiser = nil
        browser = nil
        session = nil
    }
    
    func sendRequest(completion:@escaping (Results<String>)->Void) {
        guard let currentUser = appContainer.authService.getUserdNameAndId() else {return}
        channelID = UUID().uuidString
        request = MatchingRequest(requestOwnerId: currentUser.ID, requestOwnerName: currentUser.name, mutualChannel: channelID)
        if let count = session?.connectedPeers.count, count == 1 {
            guard  let data = MatchingRequest.getDataFromPacket(request: request) else { return }
            do {
                try session?.send(data, toPeers: session!.connectedPeers, with: .reliable)
                completion(.success(nil))
            } catch let error {
                delegate?.requestError(error)
                completion(.failure(error))
            }
        }
    }
    
    func sendRequest2(channelID:String, completion:@escaping (Results<String>)->Void) {
        guard let currentUser = appContainer.authService.getUserdNameAndId() else {return}
        request = MatchingRequest(requestOwnerId: currentUser.ID, requestOwnerName: currentUser.name, mutualChannel: channelID)
        if let count = session?.connectedPeers.count, count == 1 {
            guard  let data = MatchingRequest.getDataFromPacket(request: request) else { return }
            do {
                try session?.send(data, toPeers: session!.connectedPeers, with: .reliable)
                completion(.success(nil))
            } catch let error {
                delegate?.requestError(error)
                completion(.failure(error))
            }
        }
    }
}


protocol CustomMCProtocol:NSObject{
    var delegate: CustomMCDelegate?{get set}
    func inviteUser()
    func searchUser()
    func sendRequest(completion:@escaping (Results<String>)->Void)
    func stop()
}

protocol CustomMCDelegate:NSObject{
    func pairStatus(_ status:Status)
    func decideToInvitation(by invitationOwner:String,completionHandler: (Bool) -> ())
    func showNearbyDevice(_ peerName:String)
    func requestError(_ error:Error)
    
}

enum Status{
    case connecting
    case notConnected
    case paired
}
