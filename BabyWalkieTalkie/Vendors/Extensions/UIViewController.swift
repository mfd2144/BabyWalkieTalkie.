//
//  UIViewController.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 16.07.2021.
//

import UIKit

extension UIViewController{
    public func addCaution(title:String,message:String){
        DispatchQueue.main.async {
            let cautionView = AddAnySimpleCaution(title: title, message: message)
            self.present(cautionView, animated: true, completion: nil)
        }
    }
    
    
}
