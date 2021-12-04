//
//  Token Generator Response.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 8.08.2021.
//

import Foundation

enum RootCodingKey:String, CodingKey{
    case key
    case token
}

struct TokenGeneratorResponse:Decodable{
    public let result:String?
    
    public init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootCodingKey.self)
        result = try rootContainer.decode(String.self, forKey: .token)
    }
}

struct RtmTokenGeneratorResponse:Decodable{
    public let result:String?
    
    public init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootCodingKey.self)
        result = try rootContainer.decode(String.self, forKey: .key)
    }
}
