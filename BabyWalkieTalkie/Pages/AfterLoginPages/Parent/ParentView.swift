//
//  ParentViewModel.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 18.08.2021.
//

import UIKit

final class ParentView:UIViewController{
var viewModel: ParentViewModelProtocol!
    
    let mainStack:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 20
        stack.distribution = .fillEqually
        return stack
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName:"wifi.slash"))
        return imageView
    }()
    
    let speakButton:UIButton = {
        let button = UIButton.addNewButton(imageName: nil, title: "Speak")
        button.addShadow()
        return button
    }()
    
    let testButton:UIButton = {
        let button = UIButton.addNewButton(imageName: nil, title: "Test")
        button.addShadow()
        return button
    }()
    
    let videoButton:UIButton = {
        let button = UIButton.addNewButton(imageName: nil, title: "Video")
        button.addShadow()
        return button
    }()
    
    let closeButton: UIButton = {
        let button = UIButton.addNewButton(imageName: nil, title: "Close")
        button.addShadow()
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MyColor.myBlueColor
        viewModel.startEverything()
        setSubview()
        addTarget()
    }
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for subview in mainStack.subviews{
            if let button = subview as? UIButton{
                button.reloadShadow()
            }
        }
    }
    
    private func setSubview(){
        
        
        mainStack.addArrangedSubview(speakButton)
        mainStack.addArrangedSubview(testButton)
        mainStack.addArrangedSubview(videoButton)
        mainStack.addArrangedSubview(closeButton)
        view.addSubview(mainStack)
        
        let stackHeight = 4*buttonSize+3*buttonDistance
        mainStack.putSubviewAt(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, topDis: 100, bottomDis: (-1)*buttonDistance,leadingDis: buttonDistance, trailingDis: (-1)*buttonDistance, heightFloat: stackHeight, widthFloat: nil, heightDimension: nil, widthDimension: nil)
    }
    
    private func addTarget(){
        testButton.addTarget(self, action: #selector(testBabyDevice), for: .touchUpInside)
        speakButton.addTarget(self, action: #selector(speakWithBaby(_:)), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
        videoButton.addTarget(self, action: #selector(videoStart), for: .touchUpInside)
    }
    
    
    @objc private func speakWithBaby(_ sender:UIButton){
        speakButton.pressAnimation()
        viewModel.speakPressed()
    }
    
    @objc private func testBabyDevice(){
        testButton.pressAnimation()
        viewModel.testPressed()
    }
    
    @objc private func videoStart(){
        videoButton.pressAnimation()
        viewModel.videoPressed()
    }

    @objc func closePressed(){
        closeButton.pressAnimation()
        viewModel.returnSelect()
    }
}

extension ParentView: ParentViewModelDelegate{
    func handleOutputs(outputs: ParentViewModelOutputs) {
        switch outputs {
        case .anyErrorOccurred(let error):
            addCaution(title: "Error", message: error)
        case .isLoading(let loading):
            loading ? Animator.sharedInstance.showAnimation() : Animator.sharedInstance.hideAnimation()
        }
    }
}
