//
//  PasswordFieldWithEye.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 9.08.2021.
//

import Foundation

import UIKit


final class PasswordFieldWithEye:UITextField{
    private var eyeCondition:EyeCondition = .unseen
    
    private let eyeImage:UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFit
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.isUserInteractionEnabled = true
        imageV.tintColor = .lightGray
        return imageV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        borderStyle = .line
        setEye()
        isSecureTextEntry = true
        isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    enum EyeCondition:Equatable{
        case seen
        case unseen
        
        var eyeImage:UIImage{
            switch self {
            case .seen:
                guard let image = UIImage(systemName: "eye") else {return UIImage()}
            return image
            case .unseen:
            guard let image = UIImage(systemName: "eye.slash") else {return UIImage()}
        return image
            }
        }
    }
    
    
    private func setEye(){
        eyeImage.image = EyeCondition.unseen.eyeImage
        addSubview(eyeImage)
                NSLayoutConstraint.activate([
            eyeImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6),
            eyeImage.widthAnchor.constraint(equalTo: heightAnchor),
            eyeImage.trailingAnchor.constraint(equalTo:trailingAnchor, constant: -20),
            eyeImage.centerYAnchor.constraint(equalTo: centerYAnchor)
            
        ])
        addGestures()
    }
    
    private func addGestures(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(eyeTapped))
        eyeImage.addGestureRecognizer(tapGesture)
    }
    
    @objc private func eyeTapped(_ gesture:UITapGestureRecognizer){
        switch eyeCondition {
        case .seen:
            eyeCondition = .unseen
            eyeImage.image = EyeCondition.unseen.eyeImage
            isSecureTextEntry = true
            eyeImage.tintColor = .lightGray
        case .unseen:
            eyeCondition = .seen
            eyeImage.image = EyeCondition.seen.eyeImage
            isSecureTextEntry = false
            eyeImage.tintColor = MyColor.myBlueColor
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resignFirstResponder()
    }
}

