//
//  ColorExtension.swift
//  Animation(TabBar)
//
//  Created by Mehmet fatih DOĞAN on 5.07.2021.
//

import UIKit

extension UIColor{
    static func setColor(r:Int, g:Int, b:Int)->UIColor{
        return UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1.0)
    }
    static let pulsingFillColor = UIColor.setColor(r: 179, g: 230, b: 255)
    static let backGroundColor = UIColor.setColor(r: 247, g: 255, b: 230)
    static let traceStrokeColor = UIColor.setColor(r: 102, g: 204, b: 255)
    static let outLineStrokeColor = UIColor.setColor(r: 229, g: 51, b: 109)
    static let colorBackgroud = UIColor.setColor(r: 255, g: 227, b: 227)
    static let colorButton = UIColor.setColor(r: 147, g: 181, b: 198)
    static let colorButtonLight = UIColor.setColor(r: 201, g: 204, b: 213)
    static let colorBackgroundLight = UIColor.setColor(r: 228, g: 216, b: 220)
    
}

struct MyColor{
    static let myBlueColor:UIColor = returnColor(r: 197, g: 235, b: 242)
//    UIColor.init(red: 11/255.0, green: 33/255.0, blue: 229/255.0, alpha: 1)
    static let secondColor = returnColor(r: 50, g: 80, b: 229)
    
    static func returnColor(r:CGFloat,g:CGFloat,b:CGFloat)->UIColor{
        return UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }
    
}