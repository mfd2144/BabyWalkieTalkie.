//
//  PatternView.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 8.03.2022.
//

import UIKit

final class PatterView:UIView{
    let drawPattern:CGPatternDrawPatternCallback = { _,context in
        context.addArc(center: CGPoint(x: 3, y: 3), radius: 1.5, startAngle: 0, endAngle: .pi*2, clockwise: false)
        context.setFillColor(UIColor.black.cgColor)
        context.fillPath()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {return}
        context.addArc(center: CGPoint(x: rect.width/2, y: rect.height/2), radius: rect.height/2, startAngle: 0, endAngle: .pi*2, clockwise: false)
        context.setFillColor(MyColor.buttonColor.cgColor)
        context.fillEllipse(in: rect)
        var callBack = CGPatternCallbacks(
            version: 0,
            drawPattern: drawPattern,
            releaseInfo: nil)
        guard let pattern = CGPattern(
            info: nil,
            bounds: CGRect(x: 0, y: 0, width: 3 , height: 3),
            matrix: .identity,
            xStep: 4,
            yStep: 4,
            tiling: .noDistortion ,
            isColored: true,
            callbacks: &callBack)
        else {return}
        var alpha:CGFloat = 0.8
        guard let patternSpace = CGColorSpace(patternBaseSpace: nil)
        else { return }
        context.setFillColorSpace(patternSpace)
        context.setFillPattern(pattern, colorComponents: &alpha)
        context.fillEllipse(in: rect)
        context.setLineWidth(4)
        context.setStrokeColor(UIColor.black.withAlphaComponent(0.8).cgColor)
        context.strokeEllipse(in:CGRect(x: 2, y: 2, width: rect.width-4, height: rect.height-4))
      
    
    }
}
