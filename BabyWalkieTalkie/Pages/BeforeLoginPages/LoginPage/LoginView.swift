//
//  LoginView.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 9.07.2021.
//

import UIKit
import Combine


final class LoginView:UIViewController{
    var model:LoginViewModelProtocol!

    
    let topStack:UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.spacing = buttonDistance
        stack.axis = .vertical
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let middleStack:UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.spacing = buttonDistance
        stack.alignment = .fill
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
   
    lazy var nameField:UITextField = {
        let field = UITextField()
        field.backgroundColor = .white
        field.textColor = .black
        field.borderStyle = .roundedRect
        field.layer.cornerRadius = 10
        field.keyboardType = .emailAddress
        let phString = Local.emailPlaceHolder
        field.attributedPlaceholder = NSAttributedString.init(string: phString, attributes: [NSAttributedString.Key.foregroundColor:UIColor.gray,NSAttributedString.Key.font:UIFont.preferredFont(forTextStyle: .title3)])
        field.font = UIFont.preferredFont(forTextStyle: .title3)
        field.setRightPaddingPoints(20)
        field.setLeftPaddingPoints(20)
        return field
        
    }()
    
    let passwordField:PasswordFieldWithEye = {
        let field = PasswordFieldWithEye()
        field.keyboardType = .default
        field.textColor = .black
        field.borderStyle = .roundedRect
        field.layer.cornerRadius = 10
        field.backgroundColor = .white
        let phString = Local.passwordPlaceHolder
        field.attributedPlaceholder = NSAttributedString.init(string: phString, attributes: [NSAttributedString.Key.foregroundColor:UIColor.gray,NSAttributedString.Key.font:UIFont.preferredFont(forTextStyle: .title3)])
        field.translatesAutoresizingMaskIntoConstraints = false
        field.setRightPaddingPoints(20)
        field.setLeftPaddingPoints(20)
        return field
        
        
    }()
    
    let forgotThePassword:UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.text = Local.forgotPassword
        label.textAlignment = .left
        label.textColor = MyColor.secondColor
        return label
    }()
    
    
    let loginButton:UIButton = {
        let title = Local.logIn
        let button = UIButton.addNewButton(imageName: nil, title: title)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let orLabel:UILabel = {
        let label = UILabel()
        label.text = "veya"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let googleButton :UIButton = {
        let button = UIButton.addNewButton(imageName: "google", title: Local.google)
        return button
    }()
    
    let fBButton :UIButton = {
        let button = UIButton.addNewButton(imageName: "fb", title: Local.facebook)
        return button
    }()
    
    
    let cautionLabel:UILabel = {
        let label = UILabel()
        label.text = Local.labelText
        label.textColor = .gray
        label.textAlignment = .right
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle(Local.signUp, for: .normal)
        button.setTitleColor(MyColor.secondColor, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        return button
    }()
    
    let bottomStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.distribution = .fill
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.layer.addBorder(edge: .top, color: .gray, thickness: 2)
        return stack
    }()
    
    let bottomInnerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        return stack
    }()
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MyColor.myBlueColor
        setSubviews()
        setTargets()
        nameField.delegate = self
        passwordField.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        loginButton.reloadShadow()
        fBButton.reloadShadow()
        googleButton.reloadShadow()
    }

    
    
    //MARK: - Set subviews
    private func setSubviews(){
        let middlestackViews = [fBButton,googleButton]
        for _view in middlestackViews{
            middleStack.addArrangedSubview(_view)
        }
        let topStackViews = [nameField,passwordField,forgotThePassword]
        for _view in topStackViews{
            topStack.addArrangedSubview(_view)
        }
        view.addSubview(topStack)
        view.addSubview(loginButton)
        view.addSubview(orLabel)
        view.addSubview(middleStack)
        view.addSubview(bottomStack)
        
        let stackHeight = 3*buttonSize+2*buttonDistance
        let bottomStackH = 2*buttonSize+buttonDistance
        NSLayoutConstraint.activate([
            topStack.heightAnchor.constraint(equalToConstant:stackHeight),
            topStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: buttonDistance),
            topStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: buttonDistance*(-1)),
            topStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: buttonDistance),
            middleStack.heightAnchor.constraint(equalToConstant:bottomStackH),
            middleStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: buttonDistance),
            middleStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: buttonDistance*(-1)),
            middleStack.bottomAnchor.constraint(equalTo: bottomStack.topAnchor,constant: buttonDistance*(-1)),
            orLabel.heightAnchor.constraint(equalToConstant: 60),
            orLabel.bottomAnchor.constraint(equalTo: middleStack.topAnchor),
            orLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            orLabel.widthAnchor.constraint(equalToConstant: 200),
            loginButton.heightAnchor.constraint(equalToConstant: buttonSize),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: buttonDistance),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: buttonDistance*(-1)),
            loginButton.bottomAnchor.constraint(equalTo: orLabel.topAnchor)
        ])
        
        bottomInnerStack.addArrangedSubview(cautionLabel)
        bottomInnerStack.addArrangedSubview(signUpButton)
        bottomStack.addArrangedSubview(bottomInnerStack)
     
        
        
        NSLayoutConstraint.activate([
            bottomStack.heightAnchor.constraint(equalToConstant: buttonSize),
            bottomStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomStack.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])

    
    }
    
    
    //MARK: - Add button target
    private func setTargets(){
        googleButton.addTarget(self, action: #selector(googlePressed), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        signUpButton.addTarget(self, action:#selector(signUpButtonPressed), for: .touchUpInside)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(forgotPasswordPressed))
        forgotThePassword.addGestureRecognizer(tapRecognizer)
        forgotThePassword.isUserInteractionEnabled = true
        fBButton.addTarget(self, action: #selector(getFacebookUserInfo), for: .touchUpInside)
    }
    
    @objc private func loginButtonPressed(_ sender: UIButton){
        model.logIn(nameField.text!, passwordField.text!)
        nameField.endEditing(true)
        passwordField.endEditing(true)
    }
    
    @objc private func googlePressed(){
        model.googlePressed()
        googleButton.reloadShadow()
    }
 
    
    @objc private func signUpButtonPressed(_ sender: UIButton){
        nameField.endEditing(true)
        passwordField.endEditing(true)
        model.singUp()
        signUpButton.reloadShadow()
    }
    
    @objc private func forgotPasswordPressed(){
        model.forgetPassword(nameField.text)
    }
    @objc func getFacebookUserInfo(){
        model.fbButtonPressed()
        fBButton.reloadShadow()
    }
}

//MARK: - Outputs of model
extension LoginView:LoginViewModelDelegate{
    func handleModelOutputs(_ output: LoginModelOutputs) {
        switch output {
        case .loggedIn(let response):
            switch response {
            case .failure(let error ):
                guard let error = error as?  FirebaseError else {return}
                addCaution(title: "Fail", message:error.description )
            default:
               break
            }
            
        case .setLoading(let isLoading):
            if isLoading{
                Animator.sharedInstance.showAnimation()
            }else{
                Animator.sharedInstance.hideAnimation()
            }
        case .anyErrorOccurred(let error):
            addCaution(title: NSLocalizedString("Error", comment: ""), message: error)
        }
    
    }
}

extension LoginView:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
   
    
}




