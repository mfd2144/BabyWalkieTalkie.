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
    var subscrition = Set<AnyCancellable>()
    var soundLevel = CurrentValueSubject<Float,Never>(-15)
    weak var customProtocol:CustomViewProtocol?
    
    let closeButton: UIButton = {
        let button = UIButton(type: .close)
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
        slider.minimumValue = 0
        slider.maximumValue = 30
        slider.value = 15
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    lazy var customView: CustomView = {
        let customView = CustomView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.delegate = self
        customView.buttonName = "Start"
        return customView
    }()
    
    //MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setSubviews()
        addTargets()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customProtocol = customView
        view.backgroundColor = .colorBackgroud
        soundLevel.sink {[unowned self] soundLevelFloat in
            viewModel.soundLevel = soundLevelFloat
        }.store(in: &subscrition)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel = nil
    }
    
    func setSubviews(){
        view.addSubview(customView)
        view.addSubview(sliderLabel)
        view.addSubview(slider)
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            customView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customView.topAnchor.constraint(equalTo: view.topAnchor,constant: 100),
            customView.heightAnchor.constraint(equalToConstant: 200),
            customView.widthAnchor.constraint(equalToConstant: 200),
            sliderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sliderLabel.topAnchor.constraint(equalTo: customView.bottomAnchor, constant: 100),
            sliderLabel.heightAnchor.constraint(equalToConstant: 50),
            sliderLabel.widthAnchor.constraint(equalToConstant: 150),
            slider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            slider.topAnchor.constraint(equalTo: sliderLabel.bottomAnchor, constant:10),
            slider.heightAnchor.constraint(equalToConstant: 20),
            slider.widthAnchor.constraint(equalToConstant: 150),
            closeButton.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 100),
            closeButton.heightAnchor.constraint(equalToConstant: 50),
            closeButton.widthAnchor.constraint(equalToConstant: 100),
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func addTargets(){
        closeButton.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
    }
    
    @objc func closePressed(){
        viewModel.returnSelect()
    }
    
    @objc func sliderChanged(_ sender: UISlider){
        let value = Float(Int(sender.value)*(-1))
        soundLevel.send(value)
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
                customProtocol?.setTitle("Sound")
                customProtocol?.setColor(.sound)
                customView.isUserInteractionEnabled = false
            }else{
                customProtocol?.setTitle("Ready")
                customProtocol?.setColor(.ready)
                customView.isUserInteractionEnabled = false
            }
        case .connected:
            customProtocol?.setTitle("Connecting")
            customProtocol?.setColor(.loading)
        }
    }
}

extension ListenBabyView: CustomViewDelegate{
    func broadcastPausePlay() {
    }
    
    func buttonPressed(){
        viewModel.startEverything()
    }
}
