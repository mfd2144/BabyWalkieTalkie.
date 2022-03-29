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
            return NSLocalizedString("emptyFieldError", comment: "")
        case.unsufficientText:
            return NSLocalizedString("unsufficientText", comment: "")
        case.unvalidText:
            return NSLocalizedString("unvalidText", comment: "")
        case .userSavingError:
            return NSLocalizedString("userSavingError", comment: "")
        case .unspesificError:
            return NSLocalizedString("UnknownError", comment: "")
        }
    }
}
