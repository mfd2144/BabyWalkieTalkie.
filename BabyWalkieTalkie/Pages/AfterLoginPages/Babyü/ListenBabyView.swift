//
//  ListenBabyView.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 12.08.2021.
//

import UIKit
import Combine

final class ListenBabyView:UIViewController{
    
    //MARK: - Variables
    var lightViewHeight:CGFloat?
    var viewModel:ListenBabyViewModelProtocol!
    var subscriber = Set<AnyCancellable>()
    var soundLevel = CurrentValueSubject<Float,Never>(-30)
    var originialBrightness:CGFloat?
    //MARK: - MainStack
    var mainStack:UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    //MARK: - Speak switch
    let dimButton: UISwitch = {
        let sSwitch = UISwitch()
        sSwitch.translatesAutoresizingMaskIntoConstraints = false
        return sSwitch
    }()
    
    lazy var switchLabel: UILabel = {
        let label = createLabel(labelText: "dim" )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
   //MARK: - Middle buttons
    
    lazy var closeLabel:UILabel = {
        let label = createLabel(labelText:"close" )
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }()
    lazy var testLabel:UILabel = {
        let label =  createLabel(labelText:"down" )
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }()
    lazy var cameraLabel:UILabel = {
        let label = createLabel(labelText:"up" )
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }()

    lazy var closeButton = createRoundedButton(imageName: "power")
    lazy var decreaseSensivity: UIButton = {
        let button = createRoundedButton(imageName: "minus")
        button.tag = 0
        return button
    }()
    lazy var increaseSensivity: UIButton = {
        let button = createRoundedButton(imageName: "plus")
        button.tag = 1
        return button
    }()
    lazy var s1 = createStack()
    let s2:UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    lazy var s3 = createStack()
    lazy var s1Label = createSecondStackLayer(views: [testLabel, s1])
    lazy var s2Label = createSecondStackLayer(views: [closeLabel, s2])
    lazy var s3Label = createSecondStackLayer(views: [cameraLabel, s3])
    
    
    lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [s1Label,s2Label,s3Label])
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 30
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
 
    //MARK: - TopStack and subcompenents
    lazy var emptyLabel = createLabel(labelText: " ")
    lazy var emptyLabel2 = createLabel(labelText: " ")
    lazy var sensitivityLabel = createLabel(labelText:"sensitivity")

    lazy var high = createLight()
    lazy var preHigh = createLight()
    lazy var medium: UIImageView = {
        let imageView   = createLight()
         makeGreen(imageView)
         return imageView
     }()
    lazy var preMedium:UIImageView = {
       let imageView   = createLight()
        makeGreen(imageView)
        return imageView
    }()
    lazy var low: UIImageView = {
        let imageView   = createLight()
         makeGreen(imageView)
         return imageView
     }()
    lazy var lightStack :UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emptyLabel ,sensitivityLabel,high, preHigh, medium, preMedium, low, emptyLabel2])
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
     return stack
    }()
    
    lazy var lightView:UIView = {
        let view = UIView()
        let capsule = drawCapsule()
        view.layer.addSublayer(drawCapsule())
        view.layer.zPosition = -100
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - ViewFunctions
    private func createStack()->UIStackView {
            let stack = UIStackView()
            stack.isLayoutMarginsRelativeArrangement = true
            stack.directionalLayoutMargins = .init(top: 15, leading: 15, bottom: 15, trailing: 15)
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
    }
    private func createSecondStackLayer(views:[UIView])->UIStackView  {
        let stack = UIStackView(arrangedSubviews: views)
        stack.axis = .vertical
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }
     
    private func drawCapsule()->CAShapeLayer {
        let path = UIBezierPath()
        let height = UIScreen.main.bounds.height
        let width = UIScreen.main.bounds.width
        let buttonHeight = (width-120)/3 + 20
        let topSafeHeight = view.safeAreaInsets.top
        printNew("\(topSafeHeight)")
        let maximumHeight = (height-buttonHeight)/2-topSafeHeight
        lightViewHeight = maximumHeight-buttonSize-100
        path.addArc(withCenter: CGPoint(x: 50, y: 50), radius: 50, startAngle: 0, endAngle: .pi, clockwise: false)
        path.addArc(withCenter: CGPoint(x: 50, y: lightViewHeight!), radius: 50, startAngle: .pi, endAngle: 0, clockwise: false)
        path.move(to: CGPoint(x: 100, y: 50))
        path.addLine(to: CGPoint(x: 100, y: lightViewHeight!))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = MyColor.buttonColor.cgColor
        shapeLayer.masksToBounds = false
        shapeLayer.lineJoin = .round
        return shapeLayer
}
    
    private func createRoundedButton(imageName:String)->UIButton {
        let button = UIButton()
        let image = UIImage(systemName:imageName )?.withTintColor(.black, renderingMode: .alwaysOriginal).applyingSymbolConfiguration(.init(weight: .medium))
        let imageView = UIImageView.init(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 30),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        button.backgroundColor = MyColor.buttonColor
        return button
    }
    
    private func createLabel(labelText:String)->UILabel {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textAlignment = .center
        label.text = labelText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func createLight()->UIImageView {
        let light = UIImageView()
        let image = UIImage(systemName:"capsule.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        light.image = image
        light.contentMode = .center
        return light
    }
}

extension ListenBabyView{
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubview()
        addTargets()
        view.backgroundColor = .white
        viewModel.startAudio()
        soundLevel.sink {[unowned self] soundLevelFloat in
            switch soundLevelFloat{
            case -24:makeGreen(low);makeRed(preMedium)
            case -27:makeGreen(preMedium);makeRed(medium)
            case -30:makeGreen(medium);makeRed(preHigh)
            case -33:makeGreen(preHigh);makeRed(high)
            case -36:makeGreen(high)
            default:break
            }
            viewModel.soundLevel = soundLevelFloat
        }.store(in: &subscriber)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setShadows()
        for subview in buttonStack.subviews{
            if let button = subview as? UIButton{
                button.reloadShadow()
            }
        }
    }
    
    private func makeRed(_ imageView:UIImageView ) {
        imageView.image = UIImage(systemName:"capsule.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
    }
    
    private func makeGreen(_ imageView:UIImageView ) {
        imageView.image = UIImage(systemName:"capsule.fill")?.withTintColor(.green, renderingMode: .alwaysOriginal)
    }
    
    //MARK: - Set subviews and targets

    private func setShadows() {
        decreaseSensivity.addShadow2()
        increaseSensivity.addShadow2()
        closeButton.addShadow2()
    }
    
    func setSubview() {
        s1.addArrangedSubview(decreaseSensivity)
        s2.addArrangedSubview(closeButton)
        s3.addArrangedSubview(increaseSensivity)
        mainStack.addArrangedSubview(lightStack)
        mainStack.addArrangedSubview(dimButton)
        mainStack.addArrangedSubview(buttonStack)
        view.addSubview(mainStack)
        view.addSubview(lightView)
        view.addSubview(switchLabel)
        let phoneWidth = UIScreen.main.coordinateSpace.bounds.width
        let stackWidth = phoneWidth-60//button distance
        let buttonWidth = (stackWidth-60)/3
        let stackHeight = buttonWidth + 20
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: buttonDistance),
            mainStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: (-1*buttonDistance)),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonStack.heightAnchor.constraint(equalToConstant: stackHeight),
            buttonStack.widthAnchor.constraint(equalToConstant: stackWidth),
            s1.heightAnchor.constraint(equalToConstant: buttonWidth),
            s1.widthAnchor.constraint(equalToConstant: buttonWidth),
            s2.heightAnchor.constraint(equalToConstant: buttonWidth),
            s2.widthAnchor.constraint(equalToConstant: buttonWidth),
            s3.heightAnchor.constraint(equalToConstant: buttonWidth),
            s3.widthAnchor.constraint(equalToConstant: buttonWidth),
            lightView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: buttonDistance),
            lightView.heightAnchor.constraint(equalToConstant: lightViewHeight!+50),
            lightView.widthAnchor.constraint(equalToConstant: 100),
            lightView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lightStack.heightAnchor.constraint(equalToConstant: lightViewHeight!+50),
            lightStack.widthAnchor.constraint(equalToConstant: 100),
            switchLabel.bottomAnchor.constraint(equalTo: dimButton.topAnchor, constant: (-10)),
            switchLabel.centerXAnchor.constraint(equalTo: dimButton.centerXAnchor),
            switchLabel.heightAnchor.constraint(equalToConstant: buttonDistance),
            switchLabel.widthAnchor.constraint(equalToConstant: buttonSize),

        ])
        closeButton.layer.cornerRadius = buttonWidth/2
        decreaseSensivity.layer.cornerRadius = (buttonWidth-30)/2
        increaseSensivity.layer.cornerRadius = (buttonWidth-30)/2
        Animator.sharedInstance.showAnimation()
        }

    //MARK: - Set subviews and add targets
    
    private func addTargets(){
        closeButton.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
        increaseSensivity.addTarget(self, action: #selector(changeSensivity(_:)), for: .touchUpInside)
        decreaseSensivity.addTarget(self, action: #selector(changeSensivity(_:)), for: .touchUpInside)
        dimButton.addTarget(self, action: #selector(dimPressed(_:)), for: .valueChanged)
    }
    
    @objc func closePressed(){
        closeButton.pressAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.15) { [unowned self] in
            if let brightness = originialBrightness {
                UIScreen.main.brightness = brightness
            }
            viewModel.closePressed()
        }
    }
    
    @objc func changeSensivity(_ sender:UIButton) {
        //-36(high sensivity)  -30  -24 (low sensivity)
        if sender.tag == 1 {//increase
            if soundLevel.value > -36{
                soundLevel.send(soundLevel.value-3)
            }
        }else{//decrease
            if soundLevel.value < -24{
                soundLevel.send(soundLevel.value+3)
            }
        }
    }
    
    @objc func dimPressed(_ sender: UISwitch){
        if originialBrightness == nil{
            originialBrightness = UIScreen.main.brightness
        }
        if sender.isOn{
            UIScreen.main.brightness = CGFloat(0.1)
        }else {
            UIScreen.main.brightness = originialBrightness!
        }
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
           //todo
            }else{
               //todo
            }
            break
        case .connected:
           break
        case .alreadyLogisAsBaby:
            showAlert(alertTitle: "Caution", message: "Already baby device login to system. Please change device role.", actionTitle: "Go Back", style: .default, actionClosure: viewModel.returnToSelectPage)
        case .otherDeviceDidUnpair:
            showAlert(alertTitle: "Caution", message: "Other device disconnect to this device", actionTitle: "Go Back", style: .default, actionClosure: viewModel.returnToSelectPage)
        case .mustBeConnected:
            showAlert(alertTitle: "Caution", message: "Baby walkie talkie must be connected to another device", actionTitle: "Go Back", style: .default, actionClosure: viewModel.returnToSelectPage)
        }
    }
    private func showAlert(alertTitle:String, message:String, actionTitle:String, style:UIAlertAction.Style, actionClosure:@escaping () -> Void) {
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        var action :UIAlertAction!
        switch style{
        case .cancel:
            action = UIAlertAction(title: actionTitle, style: style)
       default:
            action = UIAlertAction(title: actionTitle, style: style) { _ in actionClosure() }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension ListenBabyView: CustomViewDelegate{
    func broadcastPausePlay() {
    }
    func buttonPressed(){}
}
