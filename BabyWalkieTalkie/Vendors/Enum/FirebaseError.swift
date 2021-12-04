//
//  FirebaseError.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 13.08.2021.
//

import Foundation
public enum FirebaseError:Error{
    case errorContainer(String)
    
    var description:String{
        switch self {
        case .errorContainer(let caution):
            return caution
        }
    }
}
