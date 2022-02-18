//
//  AlertView.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 16.07.2021.
//

import UIKit

final class AddAnySimpleCaution:UIAlertController{
    convenience init(title:String,message:String,handler :((UIAlertAction) -> Void )? = nil) {
        self.init(title: title, message: message, preferredStyle: .alert)
        addAction(handler)
    }
    private func addAction(_ handler :((UIAlertAction) -> Void )?){
        let action = UIAlertAction(title: "cancel", style: .cancel, handler: handler)
        addAction(action)
    }
}
