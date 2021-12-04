//
//  ShortUserPresentation.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 12.08.2021.
//

import Foundation

struct ShortUserPresentation:Hashable{
    let name :String
    let ID:String
    func hash(into hasher: inout Hasher) {
        hasher.combine(ID)
    }
    static func ==(lhs:ShortUserPresentation,rhs:ShortUserPresentation)->Bool{
        return lhs.ID == rhs.ID
    }
}
