//
//  File.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 16.07.2021.
//

import Foundation


enum GeneralErrors:Error{
    case emptyFieldError
    case unsufficientText
    case unvalidText
    case userSavingError(String)
    case unspesificError(String?)
    
    var description:String{
        switch self {
        case .emptyFieldError:
            return "Empty textfield"
        case.unsufficientText:
            return "Text must be longer"
        case.unvalidText:
            return "Textfield must contain lowercase, uppercase, number, symbol"
        case .userSavingError:
            return "User couldn't created"
        case .unspesificError:
            return "An error occured"
        }
    }
}
