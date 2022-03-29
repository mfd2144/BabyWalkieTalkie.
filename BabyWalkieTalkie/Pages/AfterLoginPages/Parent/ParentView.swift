//
//  ParentViewModel.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 18.08.2021.
//

import UIKit

//"close" = "Close";
//"test" = "Test";
//"speak" = "Speak";
//"camera" = "Camera";
//"link" = "Link";
//"internet" = "Internet";
//"crying" = "Crying";

final class ParentView:UIViewController{
    //MARK: - Variables
    var viewModel: ParentViewModelProtocol!
    var lightViewHeight:CGFloat?
    
    //MARK: - MainStack
    var mainStack:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    //MARK: - Middle buttons
    
    lazy var closeLabel:UILabel = {
        let label = createLabel(labelText:Local2.close )
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }()
    lazy var testLabel:UILabel = {
        let label =  createLabel(labelText:Local2.test)
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }()
    lazy var cameraLabel:UILabel = {
        let label = createLabel(labelText:Local2.camera )
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }()
    
    lazy var closeButton = createRoundedButton(imageName: "power")
    lazy var testButton = createRoundedButton(imageName: "person.fill.questionmark")
    lazy var cameraButton = createRoundedButton(imageName: "camera")
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
    
    //MARK: - Speak switch
    let speakButton: UISwitch = {
        let sSwitch = UISwitch()
        sSwitch.translatesAutoresizingMaskIntoConstraints = false
        return sSwitch
    }()
    
    lazy var switchLabel: UILabel = {
        let label = createLabel(labelText: Local2.speak )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - TopStack and subcompenents
    lazy var emptyLabel = createLabel(labelText: " ")
    lazy var emptyLabel2 = createLabel(labelText: " ")
    lazy var linkLabel = createLabel(labelText:Local2.link)
    lazy var internetLabel = createLabel(labelText:Local2.intenet)
    lazy var testLabel2 = createLabel(labelText:Local2.test)
    lazy var soundLabel = createLabel(labelText:Local2.crying)
    lazy var linkLight = createLight()
    lazy var internetConnectionLight = createLight()
    lazy var testLight = createLight()
    lazy var soundLight = createLight()
    
    lazy var lightStack :UIStackView = {
        let stack = UIStackView(arrangedSubviews: [linkLabel,linkLight,internetLabel,internetConnectionLight,testLabel2,testLight,soundLabel,soundLight])
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
        let buttonHeight = (screenWidth-120)/3 + 20
        let topSafeHeight = view.safeAreaInsets.top
        let maximumHeight = (screenHeight-buttonHeight)/2-topSafeHeight
        lightViewHeight = maximumHeight-buttonSize-100
        path.addArc(withCenter: CGPoint(x: 50, y: 50), radius: 50, startAngle: 0, endAngle: .pi, clockwise: false)
        path.addArc(withCenter: CGPoint(x: 50, y: lightViewHeight!), radius: 50, startAngle: .pi, endAngle: 0, clockwise: false)
        path.move(to: CGPoint(x: 100, y: 50))
        path.addLine(to: CGPoint(x: 100, y: lightViewHeight!))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = MyColor.buttonColor.cgColor
        shapeLayer.lineJoin = .round
        shapeLayer.masksToBounds = false
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

extension ParentView{
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.startEverything()
        view.backgroundColor = .white
        setSubview()
        addTarget()
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
    
    //MARK: - Set subviews and targets
    
    private func setShadows() {
        testButton.addShadow2()
        cameraButton.addShadow2()
        closeButton.addShadow2()
    }
    
    func setSubview() {
        s1.addArrangedSubview(testButton)
        s2.addArrangedSubview(closeButton)
        s3.addArrangedSubview(cameraButton)
        mainStack.addArrangedSubview(lightStack)
        mainStack.addArrangedSubview(speakButton)
        mainStack.addArrangedSubview(buttonStack)
        view.addSubview(mainStack)
        view.addSubview(lightView)
        view.addSubview(switchLabel)
        NSLayoutConstraint.activate([
            mainStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: (-1*buttonDistance)),
            lightView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: buttonDistance),
            lightView.heightAnchor.constraint(equalToConstant: lightViewHeight!+50),
            lightView.widthAnchor.constraint(equalToConstant: 100),
            lightView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lightStack.heightAnchor.constraint(equalToConstant: lightViewHeight!),
            switchLabel.bottomAnchor.constraint(equalTo: speakButton.topAnchor, constant: (-10)),
            switchLabel.centerXAnchor.constraint(equalTo: speakButton.centerXAnchor),
            switchLabel.heightAnchor.constraint(equalToConstant: buttonDistance),
            switchLabel.widthAnchor.constraint(equalToConstant: buttonSize),
            
        ])
        switch UIDevice.current.userInterfaceIdiom{
        case.phone:
            setSubviewsForPhones()
        case.pad:
            setSubviewsForPads()
        default:
            break
        }
    }
    private func setSubviewsForPhones() {
        let phoneWidth = UIScreen.main.coordinateSpace.bounds.width
        let stackWidth = phoneWidth-60//button distance
        let buttonWidth = (stackWidth-60)/3
        let stackHeight = buttonWidth + 20
        NSLayoutConstraint.activate([
            buttonStack.heightAnchor.constraint(equalToConstant: stackHeight),
            buttonStack.widthAnchor.constraint(equalToConstant: stackWidth),
            s1.heightAnchor.constraint(equalToConstant: buttonWidth),
            s1.widthAnchor.constraint(equalToConstant: buttonWidth),
            s2.heightAnchor.constraint(equalToConstant: buttonWidth),
            s2.widthAnchor.constraint(equalToConstant: buttonWidth),
            s3.heightAnchor.constraint(equalToConstant: buttonWidth),
            s3.widthAnchor.constraint(equalToConstant: buttonWidth),
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: buttonSize),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        closeButton.layer.cornerRadius = buttonWidth/2
        testButton.layer.cornerRadius = (buttonWidth-30)/2
        cameraButton.layer.cornerRadius = (buttonWidth-30)/2
        Animator.sharedInstance.showAnimation()
    }
    
    private func setSubviewsForPads() {
        let stackWidth = screenWidth-460//button distance
        let buttonWidth = (stackWidth-60)/3
        let stackHeight = buttonWidth + 20
        NSLayoutConstraint.activate([
            buttonStack.heightAnchor.constraint(equalToConstant: stackHeight),
            buttonStack.widthAnchor.constraint(equalToConstant: stackWidth),
            s1.heightAnchor.constraint(equalToConstant: buttonWidth),
            s1.widthAnchor.constraint(equalToConstant: buttonWidth),
            s2.heightAnchor.constraint(equalToConstant: buttonWidth),
            s2.widthAnchor.constraint(equalToConstant: buttonWidth),
            s3.heightAnchor.constraint(equalToConstant: buttonWidth),
            s3.widthAnchor.constraint(equalToConstant: buttonWidth),
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: buttonSize),
            mainStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStack.widthAnchor.constraint(equalToConstant: screenWidth-300)
        ])
        closeButton.layer.cornerRadius = buttonWidth/2
        testButton.layer.cornerRadius = (buttonWidth-30)/2
        cameraButton.layer.cornerRadius = (buttonWidth-30)/2
        Animator.sharedInstance.showAnimation()
    }
    
    private func addTarget(){
        testButton.addTarget(self, action: #selector(testBabyDevice), for: .touchUpInside)
        speakButton.addTarget(self, action: #selector(speakWithBaby(_:)), for: .valueChanged)
        closeButton.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(videoStart), for: .touchUpInside)
    }
    @objc private func speakWithBaby(_ sender:UIButton){
        if sender.isEnabled{
            viewModel.speakPressed()
            //todo
        }
        
    }
    
    @objc private func testBabyDevice(){
        testButton.pressAnimation()
        viewModel.testPressed()
    }
    
    @objc private func videoStart(){
        cameraButton.pressAnimation()
        viewModel.videoPressed()
    }
    
    @objc func closePressed(){
        closeButton.pressAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.15) { [unowned self] in
            viewModel.closePressed()
        }
    }
    
    //MARK: Functions
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


extension ParentView: ParentViewModelDelegate{
    func handleOutputs(outputs: ParentViewModelOutputs) {
        switch outputs {
        case .anyErrorOccurred(let error):
            addCaution(title: Local.error, message: error)
        case .isLoading(let loading):
            loading ? Animator.sharedInstance.showAnimation() : Animator.sharedInstance.hideAnimation()
        case .babyDeviceConnect(let logic):
            linkLight.image =  logic ?  UIImage(systemName:"capsule.fill")?.withTintColor(.green, renderingMode: .alwaysOriginal) : UIImage(systemName:"capsule.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
            if logic == false{
                testLight.image = UIImage(systemName:"capsule.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
            }
        case .testResult(let result,let string):
            selectTestView(result, stringData: string)
        case.alreadyLogisAsParent:
            showAlert(alertTitle: Local.caution,
                      message:  Local2.parentCaution,
                      actionTitle: Local.goBack,
                      style: .default, actionClosure: viewModel.returnToSelectPage )
        case .babyDeviceNotConnect:
            addCaution(title: Local.caution, message:Local2.noBabyDevice )
        case .thereNotPairedDevice:
            showAlert(alertTitle: Local.caution,
                      message: Local2.lackOfPairedDev ,
                      actionTitle: Local.goBack,
                      style: .default, actionClosure:viewModel.returnToSelectPage)
        case .otherDeviceDidUnpair:
            showAlert(alertTitle: Local.caution,
                      message: Local2.noBabyDevice,
                      actionTitle: Local.goBack,
                      style: .default, actionClosure:viewModel.returnToSelectPage)
        case.videoDidNotPurchased:
            addCaution(title: Local.caution, message: Local2.videoPurchaseCaution)
        case .connectionStatus(let logic):
            internetConnectionLight.image =  logic ?  UIImage(systemName:"capsule.fill")?.withTintColor(.green, renderingMode: .alwaysOriginal) : UIImage(systemName:"capsule.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        case .crying(let bool):
            soundLight.image = bool ?  UIImage(systemName:"capsule.fill")?.withTintColor(.green, renderingMode: .alwaysOriginal) : UIImage(systemName:"capsule.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        }
    }
    func selectTestView(_ result:Bool,stringData:String?){
        DispatchQueue.main.async { [unowned self] in
            if result{
                testLight.image = UIImage(systemName:"capsule.fill")?.withTintColor(.green, renderingMode: .alwaysOriginal)
            } else {
                testLight.image = UIImage(systemName:"capsule.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
                addCaution(title: Local.caution, message: stringData ?? Local2.babyImportantCaution)
            }
        }
    }
}

extension ParentView{
    static private func makeImageView(imageName:String,color:UIColor)->UIImageView{
        let view = UIImageView()
        view.image = UIImage(systemName: imageName)?.withRenderingMode(.alwaysOriginal).withTintColor(color)
        view.contentMode = .scaleAspectFit
        return view
    }
    static private func addTitle(sectionTitle:String, _ prefferedFont:UIFont)->UILabel{
        let label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.text = sectionTitle
        label.font = prefferedFont
        label.textColor = .black
        return label
    }
    static private func addStack(_ axis:NSLayoutConstraint.Axis,distance:CGFloat = 0,views:[UIView]?=nil)->UIStackView{
        let stack = views == nil ? UIStackView() : UIStackView(arrangedSubviews: views!)
        stack.axis = axis
        stack.alignment = .fill
        stack.spacing = distance
        stack.distribution = .fillEqually
        return stack
    }
}
