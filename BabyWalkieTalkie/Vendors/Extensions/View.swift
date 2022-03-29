//
//  View.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 9.07.2021.
//

import UIKit

extension UIView{
    public func addShadow(){
        layer.masksToBounds = false
        layer.shadowColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 10
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        reloadShadow()
    }
    public func addShadow2(){
        layer.masksToBounds = false
        layer.shadowColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 20
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        reloadShadow()
    }
    
    public func reloadShadow(){
        layer.shadowPath = UIBezierPath(rect: self.layer.bounds).cgPath
    }
    
    public func removeShadow(){
        layer.shadowColor = UIColor.clear.cgColor
        layer.shadowOffset = CGSize.zero
    }
    
    
    
    public func scrollViewAccordingToKeyboard(){
        let _: Void = NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidAppear), name:UIResponder.keyboardWillChangeFrameNotification , object: nil)
    }
    
    @objc private func keyboardDidAppear(notification: NSNotification){
        guard let userInfo = notification.userInfo as? [String:Any],
        let frameAtStarting = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
        let frameAtEnding = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
        let curve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt),
              let timeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double)  else {return}
        let diffence = frameAtEnding.origin.y-frameAtStarting.origin.y
        UIView.animate(withDuration: timeInterval, delay: 0, options: .init(rawValue: curve), animations: {[unowned self] in
            self.frame.origin.y += diffence
        }, completion: nil)
    }
    
}



