//
//  View.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 9.07.2021.
//

import UIKit

extension UIView{
    func putSubviewAt(top:NSLayoutYAxisAnchor?,
                      bottom:NSLayoutYAxisAnchor?,
                      leading:NSLayoutXAxisAnchor?,
                      trailing:NSLayoutXAxisAnchor?,
                      topDis:CGFloat,
                      bottomDis:CGFloat,
                      leadingDis:CGFloat,
                      trailingDis:CGFloat,
                      heightFloat:CGFloat?,
                      widthFloat:CGFloat?,
                      heightDimension:NSLayoutDimension?,
                      widthDimension:NSLayoutDimension?
    ){
        translatesAutoresizingMaskIntoConstraints = false
        
        if top != nil{
            self.topAnchor
                .constraint(equalTo: top!, constant: topDis).isActive = true
        }
        if bottom != nil{
            self.bottomAnchor
                .constraint(equalTo: bottom!, constant: bottomDis).isActive = true
        }
        if leading != nil{
            self.leadingAnchor
                .constraint(equalTo: leading!, constant: leadingDis).isActive = true
        }
        if trailing != nil{
            self.trailingAnchor
                .constraint(equalTo: trailing!, constant: trailingDis
                ).isActive = true
        }
        if heightDimension != nil{
            self.heightAnchor
                .constraint(equalTo: heightDimension!).isActive = true
        }
        if widthDimension != nil{
            self.widthAnchor.constraint(equalTo: widthDimension!).isActive = true
        }
        if heightFloat != nil{
            self.heightAnchor.constraint(equalToConstant: heightFloat!).isActive = true
        }
        if widthFloat != nil{
            self.widthAnchor.constraint(equalToConstant: widthFloat!).isActive = true
        }
    }
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
        layer.opacity = 0
    }
    
    
    
    public func scrollViewAccordingToKeyboard(){
        let notification: Void = NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidAppear), name:UIResponder.keyboardWillChangeFrameNotification , object: nil)
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



