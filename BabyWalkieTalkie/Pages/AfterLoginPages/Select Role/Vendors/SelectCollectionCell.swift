//
//  SelectCollectionCell.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 20.08.2021.
//

import UIKit

final class SelectCollectionCell:UICollectionViewCell{
    static let identifier = "SelectCollectionCell"
    
    let cellImage:UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFit
        return imageV
    }()
    
    private let bottomLabel : UILabel = {
        let label = UILabel()
            label.textColor = .black
        label.font = UIFont.systemFont(ofSize:30 , weight: .semibold)
            label.textAlignment = .center
            label.backgroundColor = .clear
            return label
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        backgroundColor = MyColor.myBlueColor

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView(){
        layer.cornerRadius = 10
        addSubview(cellImage)
        addSubview(bottomLabel)
        cellImage.putSubviewAt(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, topDis: 0, bottomDis: 0, leadingDis: 0, trailingDis: 0, heightFloat: nil, widthFloat: nil, heightDimension: nil, widthDimension: nil)
        bottomLabel.putSubviewAt(top: nil, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, topDis: 0, bottomDis: (-1)*buttonDistance, leadingDis: 0, trailingDis: 0, heightFloat: buttonSize, widthFloat: nil, heightDimension: nil, widthDimension: nil)
        
    }
    
    func setCell(_ text:String,image:UIImage){
        bottomLabel.text = text
        cellImage.image = image
    }
    
    
}
