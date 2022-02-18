//
//  ListenBabyView.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 12.08.2021.
//

import UIKit
import Combine

final class ListenBabyView:UIViewController{
    
    var viewModel:ListenBabyViewModelProtocol!
    var subscriber = Set<AnyCancellable>()
    var soundLevel = CurrentValueSubject<Float,Never>(-15)
    let closeButton: UIButton = {
        let button = UIButton.addNewButton(imageName: nil, title: "Close")
        button.addShadow()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let sliderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .none
        label.textAlignment = .center
        label.text = "Precision"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let slider:UISlider = {
        let slider = UISlider()
        slider.minimumValue = 20
        slider.maximumValue = 34
        slider.value = 27
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    lazy var customView: CustomView = {
        let customView = CustomView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width-2*buttonDistance, height: 200))
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.delegate = self
        customView.buttonName = "Start"
        return customView
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fill
        stack.spacing = buttonDistance
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        return stack
    }()
    
    let customStackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fill
        stack.spacing = buttonDistance
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center
        return stack
    }()
    
    //MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setSubviews()
        addTargets()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MyColor.myBlueColor
        viewModel.startAudio()
        soundLevel.sink {[unowned self] soundLevelFloat in
            viewModel.soundLevel = soundLevelFloat
        }.store(in: &subscriber)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        closeButton.reloadShadow()
    }
    //MARK: - Set subviews and add targets
    func setSubviews(){
        customStackView.addArrangedSubview(customView)
        let subviews = [customStackView,sliderLabel,slider,closeButton]
        for subview in subviews{
            stackView.addArrangedSubview(subview)
        }
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: buttonDistance*(-1)),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: buttonDistance),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: buttonDistance*(-1)),
            closeButton.heightAnchor.constraint(equalToConstant: buttonSize)
        ])
        Animator.sharedInstance.showAnimation()
    }
    
    private func addTargets(){
        closeButton.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
    }
    
    @objc func closePressed(){
        viewModel.closePressed()
    }
    
    @objc func sliderChanged(_ sender: UISlider){
        let value = Float(Int(sender.value)*(-1))
        soundLevel.send(value)
    }
    //MARK: - Functions
    private func showAlert(){
        let alert = UIAlertController(title: "Caution", message: "Already baby device login to system. Please change device role.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Go Back", style: .default) {[unowned self] _ in
            viewModel.returnToSelectPage()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension ListenBabyView:ListenBabyViewModelDelegate{
    func handleOutputs(_ outputs: ListenBabyViewModelOutputs) {
        switch  outputs {
        case .anyErrorOccurred(let error):
            addCaution(title: "Caution", message: error)
        case.isLoading(let loading):
            loading ? Animator.sharedInstance.showAnimation(): Animator.sharedInstance.hideAnimation()
        case .soundComing(let sound):
            if  sound{
                customView.setTitle("Sound")
                customView.setColor(.sound)
                customView.isUserInteractionEnabled = false
            }else{
                customView.setTitle("Ready")
                customView.setColor(.ready)
                customView.isUserInteractionEnabled = false
            }
        case .connected:
            customView.setTitle("Waiting for parent")
            customView.setColor(.loading)
        case .alreadyLogisAsBaby:
            showAlert()
        }
    }
}

extension ListenBabyView: CustomViewDelegate{
    func broadcastPausePlay() {
    }
    func buttonPressed(){}
}
