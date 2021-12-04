//
//  SignUpMethodPageVİew.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 12.07.2021.
//

import UIKit

final class SignUpMethodView:UIViewController{
    
    var viewModel:SignUpMethodViewModel!
    var codeTapGesture:UITapGestureRecognizer!
    
    let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = buttonDistance
        stack.distribution = .fillEqually
        return stack
    }()
    
    let topStack :UIStackView = {
        let label1 = UILabel()
        label1.text = Local.title
        label1.textAlignment = .center
        label1.font = UIFont.preferredFont(forTextStyle: .title1)
        label1.textColor = .none
        let label2 = UILabel()
        label2.text = Local.subtitle
        label2.textAlignment = .center
        label2.font = UIFont.preferredFont(forTextStyle: .footnote)
        label2.textColor = .systemGray
        let stack = UIStackView(arrangedSubviews: [label1,label2])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = buttonDistance
        stack.alignment = .fill
        return stack
    }()
    
    lazy var emailTextField: UITextField = {
        let phString = Local.emailPlaceholder
        let textField = createTextField(placeHolderText: phString, type: .emailAddress)
        return textField
    }()
    
 
    
    lazy var emailTextField2: UITextField = {
        let phString = Local.emailPlaceholder2
        let textField = createTextField(placeHolderText: phString, type: .emailAddress)
        return textField
    }()
    
    lazy var userNameTextField: UITextField = {
        let phString =  Local.namePlaceholder
        let textField = createTextField(placeHolderText: phString, type: .default)
        return textField
    }()
    
    
    let passwordTextField: PasswordFieldWithEye = {
        let textField = PasswordFieldWithEye()
        let phString = Local.passwordPlaceholder
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.attributedPlaceholder = NSAttributedString.init(string: phString, attributes: [NSAttributedString.Key.foregroundColor:UIColor.gray,NSAttributedString.Key.font:UIFont.preferredFont(forTextStyle: .title3)])
        textField.setRightPaddingPoints(20)
        textField.setLeftPaddingPoints(20)
        return textField
    }()
    

    let nextButton: UIButton = {
        let button = UIButton.addNewButton(imageName: nil, title: Local.button)
        return button
    }()
    
    
    
    //MARK: - App life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField2.delegate = self
        emailTextField.delegate = self
        userNameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MyColor.myBlueColor
        setSubviews()
        setTarget()
        view.scrollViewAccordingToKeyboard()
        
    }
    
    override func viewDidLayoutSubviews() {
        nextButton.reloadShadow()
    }


    //MARK: - Add subviews
    
    private func setSubviews(){
        
        switch UIDevice.current.userInterfaceIdiom{
        case.phone:
            setSubviewsForPhones()
        case.pad:
            setSubviewsForPads()
        default:
            break
        }
        
    }

    private func setSubviewsForPhones(){
        let views = [ emailTextField,emailTextField2 ,userNameTextField,passwordTextField,nextButton]
        for _view in views{
            stack.addArrangedSubview(_view)
        }
        view.addSubview(topStack)
        view.addSubview(stack)
        
        let stackHeight = 5*buttonSize+4*buttonDistance
        topStack.putSubviewAt(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, topDis: 0, bottomDis: 0, leadingDis: buttonDistance, trailingDis: (-1)*buttonDistance, heightFloat: 100, widthFloat: nil, heightDimension: nil, widthDimension: nil)
       
        stack.putSubviewAt(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, topDis: 0, bottomDis: (-1)*buttonDistance, leadingDis: buttonDistance, trailingDis: (-1)*buttonDistance, heightFloat: stackHeight, widthFloat: nil, heightDimension: nil, widthDimension: nil)
        
    }
    
    private func setSubviewsForPads(){
        let views = [ emailTextField,emailTextField2 ,userNameTextField,passwordTextField,nextButton]
        for _view in views{
            stack.addArrangedSubview(_view)
        }
        view.addSubview(topStack)
        view.addSubview(stack)
        

        
        topStack.putSubviewAt(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, topDis: 0, bottomDis: 0, leadingDis: 200, trailingDis: -200, heightFloat: 200, widthFloat: nil, heightDimension: nil, widthDimension: nil)
       
        stack.putSubviewAt(top: topStack.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, topDis: 30, bottomDis: 0, leadingDis: 200, trailingDis: -200, heightFloat: UIScreen.main.bounds.height/4, widthFloat: nil, heightDimension: nil, widthDimension: nil)
        
    }
    
    //MARK: - Add target
    private func setTarget(){
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
    }
    
    @objc private func nextButtonPressed(){
        guard  emailTextField.text == emailTextField2.text else {return}
        let user = UserInfo(userName: userNameTextField.text, password: passwordTextField.text, mail: emailTextField.text)
        emailTextField.endEditing(true)
        emailTextField2.endEditing(true)
        passwordTextField.endEditing(true)
        userNameTextField.endEditing(true)
        viewModel.signUp(user)
    }
}

//MARK: - Custom segment controller methods


extension SignUpMethodView:SignUpMethodViewModelDelegate{
    func handleOutput(_ output: SignUpMethodViewModelOutputs) {
        switch output {
        case .showAnyAlert(let caution):
            addCaution(title: Local.caution, message: caution)

        case .isLoading(let loading):
            if loading{
                Animator.sharedInstance.showAnimation()
            }else{
                Animator.sharedInstance.hideAnimation()
            }
          
        }
    }
    
    //MARK: - Other Functions
    func createTextField(placeHolderText:String,type:UIKeyboardType)->UITextField{
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.textColor = .black
        textField.layer.cornerRadius = 10
        textField.backgroundColor = .white
        textField.keyboardType = type
        textField.attributedPlaceholder = NSAttributedString.init(string: placeHolderText, attributes: [NSAttributedString.Key.foregroundColor:UIColor.gray,NSAttributedString.Key.font:UIFont.preferredFont(forTextStyle: .title3)])
        textField.setRightPaddingPoints(20)
        textField.setLeftPaddingPoints(20)
        return textField
    }
}


extension SignUpMethodView:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextButtonPressed()
        textField.endEditing(true)
        return true
    }
}






