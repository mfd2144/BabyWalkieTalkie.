//
//  IdentityData.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 3.02.2022.
//

import Foundation
struct IdentityData:Codable{
    let sender:String
    enum CodingKeys:String,CodingKey{
        case sender
    }
}

extension IdentityData{
    static func getData(id:IdentityData)->Data?{
        do {
            let data = try PropertyListEncoder.init().encode(id)
            return data
        } catch  let error as NSError{
            return nil
        }
       
    }
    
    static func getId(data:Data)->IdentityData?{
        do{
            let id = try PropertyListDecoder.init().decode(IdentityData.self, from: data)
            return id
        }catch let error as NSError{
            return nil
        }
    }
}
