//
//  UIButton extension.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 2.11.2021.
//

import UIKit


extension UIButton {

    
    static func addNewButton(imageName:String?,title:String)->UIButton{
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.backgroundColor = .white
     
        button.addShadow()
        if imageName != nil{
            let buttonImage = UIImage(named: imageName!)?.withRenderingMode(.alwaysOriginal).withTintColor(.gray)
            var image:UIImage!
            
            if let buttonImage = buttonImage  {
                image = buttonImage
            }else{
                image = UIImage()
            }
            
            button.setImage(image, for: .normal)
            button.setTitle(title, for: .normal)


            let bImage = button.imageView!
            let bTitle = button.titleLabel!

            bTitle.font = .preferredFont(forTextStyle: .title3)
            button.setTitleColor(UIColor.black, for: .normal)
            button.setTitleColor(.gray, for: .highlighted)
            bTitle.textAlignment = .right
            bImage.contentMode = .scaleAspectFit
            bTitle.translatesAutoresizingMaskIntoConstraints = false
            bImage.translatesAutoresizingMaskIntoConstraints = false
        
            button.contentHorizontalAlignment = .center
            
            let textSize = bTitle.intrinsicContentSize.width
            let leftPadding = (UIScreen.main.bounds.width-(textSize+buttonSize)-(2*buttonDistance))/2
            
            NSLayoutConstraint.activate([
                bImage.heightAnchor.constraint(equalTo: button.heightAnchor,multiplier: 0.5),
                bImage.widthAnchor.constraint(equalTo: button.heightAnchor),
                bImage.centerYAnchor.constraint(equalTo: button.centerYAnchor),
                bImage.leadingAnchor.constraint(equalTo: button.leadingAnchor,constant: leftPadding)
            ])
            
         
        }else{
            button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
            button.setTitleColor(UIColor.black, for: .normal)
            button.setTitle(title, for: .normal)
        }
        
        return button
        
    }
    
    public func pressAnimation(){
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.5, options: .curveEaseIn) {
            self.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        } completion: { _ in
            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 2, options: .curveEaseIn) {
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }

        
    }
    

    
}

