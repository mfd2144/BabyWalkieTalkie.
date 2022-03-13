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
    private var seenText:String = ""
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
        delegate = self
        setEye()
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
            let unseenText = String(repeating: "*", count: (text?.count ?? 0))
            text = unseenText
            eyeImage.tintColor = .lightGray
        case .unseen:
            eyeCondition = .seen
            eyeImage.image = EyeCondition.seen.eyeImage
            text = seenText
            eyeImage.tintColor = MyColor.secondColor
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resignFirstResponder()
    }
}
extension PasswordFieldWithEye:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if eyeCondition == .unseen{
            let unseenText = String(repeating: "*", count: (textField.text?.count ?? 0))
            textField.text = unseenText
        }
        if let char = string.cString(using: String.Encoding.utf8) {
              let isBackSpace = strcmp(char, "\\b")
              if (isBackSpace == -92) {
                  seenText.removeLast()
              }else{
                  seenText += string
              }
          }
        return true
    }
}
