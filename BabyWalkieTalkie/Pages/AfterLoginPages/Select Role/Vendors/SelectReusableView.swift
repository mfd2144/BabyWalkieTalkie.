//
//  SelectReusable.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 20.08.2021.
//

import UIKit

final class SelectReusableView:UICollectionReusableView{
    static let identifier = "SelectReusable"
    
    let headerLabel: UILabel = {
    let label = UILabel()
        label.textColor = .black
        label.layer.cornerRadius = 10
        label.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView(){
        addSubview(headerLabel)
        headerLabel.putSubviewAt(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, topDis: 0, bottomDis: 0, leadingDis: 0, trailingDis: 0, heightFloat: nil, widthFloat: nil, heightDimension: nil, widthDimension: nil)
    }
    
    func setLabel(_ text:String){
        headerLabel.text = text
    }
    
}
