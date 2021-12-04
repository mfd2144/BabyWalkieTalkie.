//
//  DecoderErrors.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 13.07.2021.
//

import Foundation

enum DecodeErrors:Error{
    case urlPathFail(String)
    case decodeError(String)
    case emptyData
    
    var description:String{
        switch self {
        case .decodeError(let string):
            return string
        case .urlPathFail(let string):
            return string
        case.emptyData:
            return "Empty Data"
        }
    }
}
