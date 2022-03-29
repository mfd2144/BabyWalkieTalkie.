//
//  Button Animation.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 18.08.2021.
//

import Foundation
import UIKit

class CustomView:UIView{
    weak var delegate:CustomViewDelegate?
    let traceLayer = CAShapeLayer()
    let pulsingLayer = CAShapeLayer()
    var buttonName:String?{
        didSet{
            label.text = buttonName
        }
    }
    var color:CustomViewColor = .inital
    var tabRecognizer: UITapGestureRecognizer!
    let label :UILabel = {
        let label = UILabel()
        label.frame.size = CGSize(width: 150, height: 50)
        label.textColor = .colorButton
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        label.textAlignment = .center
        return label
        
    }()
    private func checkAppOnForeground(){
        NotificationCenter.default.addObserver(self, selector: #selector(didComeForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func didComeForeground(){
        pulsingAnimation()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addPaths()
        addTarget()
    }

    private func addTarget(){
        tabRecognizer = UITapGestureRecognizer(target: self, action: #selector(tabBar))
        addGestureRecognizer(tabRecognizer)
        isUserInteractionEnabled = true
    }
    @objc func tabBar(){
        delegate?.broadcastPausePlay()
        delegate?.buttonPressed()
    }
    private func addPaths(){
        let circularPath = UIBezierPath(arcCenter: CGPoint.zero, radius: 100, startAngle:0, endAngle: 2*CGFloat.pi, clockwise: true)
        checkAppOnForeground()
        backgroundColor = UIColor.clear
        pulsingLayer.path = circularPath.cgPath
        pulsingLayer.strokeColor = UIColor.clear.cgColor
        pulsingLayer.lineWidth = 10
        pulsingLayer.fillColor = color.setColor().withAlphaComponent(0.6).cgColor
        pulsingLayer.position = center
        pulsingAnimation()
        traceLayer.path = circularPath.cgPath
        traceLayer.strokeColor = color.setColor().cgColor
        traceLayer.lineWidth = 20
        traceLayer.position = center
        traceLayer.fillColor = UIColor.colorBackgroundLight.cgColor
        layer.addSublayer(pulsingLayer)
        layer.addSublayer(traceLayer)
        addSubview(label)
        label.center = center
        pulsingAnimation()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func pulsingAnimation(){
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.2
        animation.duration = 2
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.repeatCount = Float.infinity
        pulsingLayer.add(animation, forKey: "pulsing")
    }
}
extension CustomView:CustomViewProtocol{
    func setTitle(_ title: String) {
        DispatchQueue.main.async { [unowned self] in
            label.text = title
        }
    }
    func setColor(_ color: CustomViewColor) {
        pulsingLayer.fillColor = color.setColor().withAlphaComponent(0.6).cgColor
        traceLayer.strokeColor = color.setColor().cgColor
        pulsingAnimation()
    }
}


