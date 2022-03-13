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
        popoverPresentationController?.sourceView = self.view
        let xOrigin = self.view.bounds.width / 2
        let popoverRect = CGRect(x: xOrigin, y: 0, width: 1, height: 1)
        popoverPresentationController?.sourceRect = popoverRect
        popoverPresentationController?.permittedArrowDirections = .up

        addAction(action)
    }
}
