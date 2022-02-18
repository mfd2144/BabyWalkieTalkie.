//
//  LogOutAlert.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 10.08.2021.
//

import UIKit



protocol LogOutAlertDelegate:AnyObject{
    func handleError(_ error:Error)
}


class LogOutAlert:UIAlertController{
    weak var delegate:LogOutAlertDelegate?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = LogOutLocal.logOut
        self.message = LogOutLocal.message
        addActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addActions(){
        let cancelAction = UIAlertAction(title: LogOutLocal.cancel, style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: LogOutLocal.logOut, style: .default) {_ in
            appContainer.authService.signOut()
        }
        self.addAction(cancelAction)
        self.addAction(okAction)
        
    }
    
}

struct LogOutLocal {
    static let logOut = NSLocalizedString("LogOut", comment: "")
    static let message = NSLocalizedString("LogOut.message", comment: "")
    static let cancel = NSLocalizedString("Cancel" , comment: "")
}

