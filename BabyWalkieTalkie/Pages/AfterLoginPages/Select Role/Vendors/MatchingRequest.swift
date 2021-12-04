//
//  MatchingRequest.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 1.09.2021.
//

import Foundation

struct MatchingRequest:Codable{
    let requestOwnerId:String
    let requestOwnerName:String
    let mutualChannel:String
    
    enum CodingKeys: String, CodingKey {
        case requestOwnerId,requestOwnerName,mutualChannel
    }
    
    static func getDataFromPacket(request: MatchingRequest) -> Data?{
        do{
            let data = try PropertyListEncoder.init().encode(request)
            return data
        }catch let error as NSError{
            print(error.localizedDescription)
        }
        return nil
    }
    
    static func getPacketFromData(data: Data) -> MatchingRequest?{
        do{
            let packet = try PropertyListDecoder.init().decode(MatchingRequest.self, from: data)
            return packet
        }catch let error as NSError{
            print(error.localizedDescription)
        }
        return nil
    }
}

extension MatchingRequest{
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        requestOwnerId = try values.decode(String.self, forKey: .requestOwnerId)
        requestOwnerName = try values.decode(String.self, forKey: .requestOwnerName)
        mutualChannel = try values.decode(String.self, forKey: .mutualChannel)
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(requestOwnerId, forKey: .requestOwnerId)
        try container.encode(requestOwnerName, forKey: .requestOwnerName)
        try container.encode(mutualChannel, forKey: .mutualChannel)
    }
}
