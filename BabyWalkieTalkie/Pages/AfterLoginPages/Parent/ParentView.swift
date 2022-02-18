//
//  ParentViewModel.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 18.08.2021.
//

import UIKit

final class ParentView:UIViewController{
    //MARK: - Variables
    var viewModel: ParentViewModelProtocol!
    let upperStack:UIStackView = {
       let stack = ParentView.addStack(.horizontal)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    let upperStack_L:UIStackView = {
        let stack = ParentView.addStack(.vertical)
        return stack
    }()
    let upperStack_R:UIStackView = {
        let stack = ParentView.addStack(.vertical)
        return stack
    }()
    lazy var babyPhoneConditionStack: UIStackView = {
        let stack = ParentView.addStack(.vertical,views: [babyPhoneConditionTitle,babyPhoneConditionView,babyPhoneConditionFootnote])
        return stack
    }()
    let babyPhoneConditionTitle:UILabel = {
        let label = ParentView.addTitle(sectionTitle: "Baby Phone Condition", .preferredFont(forTextStyle: .headline))
        return label
    }()
    let babyPhoneConditionView :UIImageView = {
        // does baby phone connect or not
        let image = ParentView.makeImageView(imageName: "iphone.slash", color: .red)
        return image
    }()
    
    let babyPhoneConditionFootnote :UILabel = {
        let label = ParentView.addTitle(sectionTitle: "Offline", .preferredFont(forTextStyle: .footnote))
        return label
    }()
    lazy var babyPhoneTestStack: UIStackView = {
        let stack = ParentView.addStack(.vertical,views: [babyPhoneTest,babyTestResult,babyTestResultFootnote])
        return stack
    }()
    let babyPhoneTest:UILabel = {
        let label = ParentView.addTitle(sectionTitle: "Baby Phone Test", .preferredFont(forTextStyle: .headline))
        return label
    }()
    let babyTestResult :UIImageView = {
        // last test result
        let image = ParentView.makeImageView(imageName: "questionmark.circle", color: .red)
        //checkmark.circle
        //xmark.circle
        return image
    }()
    
    let babyTestResultFootnote :UILabel = {
        let label = ParentView.addTitle(sectionTitle: "Not Done", .preferredFont(forTextStyle: .footnote))
        return label
    }()
    
    
    
    lazy var speakListenStack: UIStackView = {
        let stack = ParentView.addStack(.vertical,views: [speakListen,speakListenView,speakListenFootnote])
        return stack
    }()
    let speakListen:UILabel = {
        let label = ParentView.addTitle(sectionTitle: "Speak/Listen", .preferredFont(forTextStyle: .headline))
        return label
    }()
    let speakListenView :UIImageView = {
        // is parent audience or speaker
        let image = ParentView.makeImageView(imageName: "speaker.slash", color: .gray)
        //speaker
        return image
    }()
    let speakListenFootnote :UILabel = {
        let label = ParentView.addTitle(sectionTitle: "Listen", .preferredFont(forTextStyle: .footnote))
        return label
    }()
    
    lazy var isThereSoundStack: UIStackView = {
        let stack = ParentView.addStack(.vertical,views: [isThereSoundTitle,isThereSound,isThereSoundFootnote])
        return stack
    }()
    let isThereSoundTitle:UILabel = {
        let label = ParentView.addTitle(sectionTitle: "Is baby Crying?", .preferredFont(forTextStyle: .headline))
        return label
    }()
    let isThereSound :UIImageView = {
        // is baby crying or not
        let image = ParentView.makeImageView(imageName: "antenna.radiowaves.left.and.right.slash", color: .red)
        //antenna.radiowaves.left.and.right
        return image
    }()
    let isThereSoundFootnote :UILabel = {
        let label = ParentView.addTitle(sectionTitle: "No", .preferredFont(forTextStyle: .footnote))
        return label
    }()
    let buttonStack:UIStackView = {
        let stack = ParentView.addStack(.vertical, distance: buttonDistance)
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
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.startEverything()
        view.backgroundColor = MyColor.myBlueColor
        setSubview()
        addTarget()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for subview in buttonStack.subviews{
            if let button = subview as? UIButton{
                button.reloadShadow()
            }
        }
    }
    //MARK: - Set subviews and targets
    private func setSubview(){
        upperStack.addArrangedSubview(upperStack_L)
        upperStack.addArrangedSubview(upperStack_R)
        upperStack_R.addArrangedSubview(babyPhoneConditionStack)
        upperStack_R.addArrangedSubview(isThereSoundStack)
        upperStack_L.addArrangedSubview(speakListenStack)
        upperStack_L.addArrangedSubview(babyPhoneTestStack)
        buttonStack.addArrangedSubview(speakButton)
        buttonStack.addArrangedSubview(testButton)
        buttonStack.addArrangedSubview(videoButton)
        buttonStack.addArrangedSubview(closeButton)
        view.addSubview(buttonStack)
        view.addSubview(upperStack)
        
        let stackHeight = 4*buttonSize+3*buttonDistance
        buttonStack.putSubviewAt(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, topDis: 100, bottomDis: (-1)*buttonDistance,leadingDis: buttonDistance, trailingDis: (-1)*buttonDistance, heightFloat: stackHeight, widthFloat: nil, heightDimension: nil, widthDimension: nil)
        
        upperStack.putSubviewAt(top: view.safeAreaLayoutGuide.topAnchor, bottom: buttonStack.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, topDis: 0, bottomDis: (-1)*buttonDistance,leadingDis: buttonDistance, trailingDis: (-1)*buttonDistance, heightFloat: nil, widthFloat: nil, heightDimension: nil, widthDimension: nil)
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
        viewModel.closePressed()
    }
    //MARK: Functions
    private func showAlert(alertTitle:String,message:String,actionTitle:String,style:UIAlertAction.Style,actionClosure:@escaping () -> Void){
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
            addCaution(title: "Error", message: error)
        case .isLoading(let loading):
            loading ? Animator.sharedInstance.showAnimation() : Animator.sharedInstance.hideAnimation()
        case .babyDeviceConnect(let logic):
            babyPhoneConditionView.image = logic ? UIImage(systemName: "iphone")?.withTintColor(.green, renderingMode: .alwaysOriginal) : UIImage(systemName: "iphone.slash")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        case .testResult(let result,let time):
                selectTestView(result, time: time)
        case.alreadyLogisAsParent:
            showAlert(alertTitle: "Caution",
                    message:  "Already parent device login to system. Please change device role.",
                      actionTitle: "Go Back",
                      style: .default, actionClosure: viewModel.returnToSelectPage )
        case .listener(let listen):
            DispatchQueue.main.async {[unowned self] in
                if listen{
                    speakButton.setTitle("Speak", for: .normal)
                }else{
                        speakButton.setTitle("Listen", for: .normal)
                    }
                }
        case .babyDeviceNotConnect:
            showAlert(alertTitle: "Caution",
                    message:  "Baby device isn't connected yet",
                      actionTitle: "OK",
                      style: .default, actionClosure:viewModel.returnToSelectPage)
        case .thereNotPairedDevice:
            showAlert(alertTitle: "Caution",
                    message:  "There isn't any paired device yet",
                      actionTitle: "Go Back",
                      style: .default, actionClosure:viewModel.returnToSelectPage)
        case .otherDeviceDidUnpair:
            showAlert(alertTitle: "Caution",
                    message:  "other device unpaired ",
                      actionTitle: "Go Back",
                      style: .default, actionClosure:viewModel.returnToSelectPage)
        }
        }
    func selectTestView(_ result:Bool,time:String?){
        DispatchQueue.main.async { [unowned self] in
            babyTestResult.image = result ? UIImage(systemName: "checkmark.circle")?.withTintColor(.green, renderingMode: .alwaysOriginal):UIImage(systemName: "xmark.circle")?.withTintColor(.red, renderingMode: .alwaysOriginal)
            babyTestResultFootnote.text = result ? time : "result fail"
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
