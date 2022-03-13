//
//  TransitionView.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 10.03.2022.
//

import Foundation
import UIKit


final class TransionView:UIView{
    
    let imageView: UIImageView = {
        let imageV = UIImageView()
        let image = UIImage(named: "icon")?.withRenderingMode(.alwaysOriginal).withTintColor(MyColor.pink)
        imageV.image = image
        imageV.contentMode = .scaleAspectFit
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    let babyView: UIImageView = {
        let imageV = UIImageView()
        let image = UIImage(named: "baby_1")?.withRenderingMode(.alwaysOriginal).withTintColor(MyColor.pink)
        imageV.image = image
        imageV.contentMode = .scaleAspectFit
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    let parentView: UIImageView = {
        let imageV = UIImageView()
        let image = UIImage(named: "mother_1")?.withRenderingMode(.alwaysOriginal).withTintColor(MyColor.pink)
        imageV.image = image
        
        imageV.contentMode = .scaleAspectFit
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = NSLocalizedString("firstPC.title", comment: "")
        label.textColor = MyColor.purple
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(imageView)
        addSubview(babyView)
        addSubview(parentView)
        addSubview(label)
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: frame.height/2-2*buttonSize),
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: leadingAnchor,constant: 100),
            imageView.widthAnchor.constraint(equalToConstant: frame.width),
            babyView.widthAnchor.constraint(equalToConstant: frame.width/4),
            babyView.heightAnchor.constraint(equalToConstant: frame.width/4),
            babyView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -1*frame.width/5),
            babyView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,constant: buttonSize),
            parentView.widthAnchor.constraint(equalToConstant: frame.width/3),
            parentView.heightAnchor.constraint(equalToConstant: frame.width/3),
            parentView.centerXAnchor.constraint(equalTo: babyView.centerXAnchor),
            parentView.topAnchor.constraint(equalTo: babyView.bottomAnchor,constant: frame.width/4),
            label.widthAnchor.constraint(equalTo: widthAnchor),
            label.heightAnchor.constraint(equalToConstant: 3*buttonSize),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,constant:-1*buttonSize)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {return}
        context.move(to: CGPoint(x: 0, y: 0))
        context.addLine(to: CGPoint(x: 0, y: rect.height/2))
        context.addQuadCurve(to: CGPoint(x: rect.width, y: rect.height/2+2*buttonSize), control: CGPoint(x: rect.width/2-buttonDistance, y: rect.height/2+3*buttonSize))
        context.addLine(to: CGPoint(x: rect.width, y: 0))
        context.setFillColor(MyColor.green.cgColor)
        context.fillPath()
    }
}
