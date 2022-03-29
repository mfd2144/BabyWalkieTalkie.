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
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
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
        label2.font = UIFont.preferredFont(forTextStyle: .body)
        label2.textColor = .systemGray
        let stack = UIStackView(arrangedSubviews: [label1,label2])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var emailTextField: UITextField = {
        let phString = Local.emailPlaceholder
        let textField = createTextField(placeHolderText: phString, type: .emailAddress)
        textField.backgroundColor = MyColor.buttonColor
        textField.keyboardType = .default
        return textField
    }()
    
    lazy var emailTextField2: UITextField = {
        let phString = Local.emailPlaceholder2
        let textField = createTextField(placeHolderText: phString, type: .emailAddress)
        textField.backgroundColor = MyColor.buttonColor
        textField.keyboardType = .default
        return textField
    }()
    
    lazy var userNameTextField: UITextField = {
        let phString =  Local.namePlaceholder
        let textField = createTextField(placeHolderText: phString, type: .default)
        textField.backgroundColor = MyColor.buttonColor
        textField.keyboardType = .default
        return textField
    }()
    
    let passwordTextField: PasswordFieldWithEye = {
        let textField = PasswordFieldWithEye()
        let phString = Local.passwordPlaceholder
        textField.borderStyle = .roundedRect
        textField.keyboardType = .default
        textField.layer.cornerRadius = 10
        textField.textColor = .black
        textField.backgroundColor = MyColor.buttonColor
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setSubviews()
        setTarget()
        view.scrollViewAccordingToKeyboard()
    }
    
    override func viewDidLayoutSubviews() {
        nextButton.reloadShadow()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape{
            emailTextField.resignFirstResponder()
            emailTextField2.resignFirstResponder()
            userNameTextField.resignFirstResponder()
            passwordTextField.resignFirstResponder()
        } else{
            emailTextField.resignFirstResponder()
            emailTextField2.resignFirstResponder()
            userNameTextField.resignFirstResponder()
            passwordTextField.resignFirstResponder()
        }
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
        topStack.spacing = buttonDistance
        stack.spacing = buttonDistance
        
        NSLayoutConstraint.activate([
            topStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topStack.heightAnchor.constraint(equalToConstant: 2*buttonDistance+buttonSize),
            topStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: buttonDistance),
            topStack.widthAnchor.constraint(equalToConstant:screenWidth-buttonSize),
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.heightAnchor.constraint(equalToConstant: stackHeight),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -1*buttonDistance),
            stack.widthAnchor.constraint(equalToConstant:screenWidth-buttonSize)
        ])
    }
    
    private func setSubviewsForPads(){
        let views = [ emailTextField,emailTextField2 ,userNameTextField,passwordTextField,nextButton]
        for _view in views{
            stack.addArrangedSubview(_view)
        }
        view.addSubview(topStack)
        view.addSubview(stack)
        let stackHeight = 5*buttonSize+4*buttonDistance
        topStack.spacing = buttonDistance
        stack.spacing = buttonDistance
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.heightAnchor.constraint(equalToConstant: stackHeight),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -1*buttonDistance),
            stack.widthAnchor.constraint(equalToConstant:screenWidth-300),
            topStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topStack.heightAnchor.constraint(equalToConstant: 2*buttonDistance+buttonSize),
            topStack.bottomAnchor.constraint(equalTo: stack.topAnchor,constant:-1*buttonDistance),
            topStack.widthAnchor.constraint(equalToConstant:screenWidth-300),
        ])
    }
    
    //MARK: - Add target
    private func setTarget(){
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
    }
    
    @objc private func nextButtonPressed() {
        nextButton.pressAnimation()
        emailTextField.endEditing(true)
        emailTextField2.endEditing(true)
        passwordTextField.endEditing(true)
        userNameTextField.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.15) {[unowned self] in
            nextPagePreparation()
        }
    }
    private func nextPagePreparation(){
        guard let trimmedEmail = emailTextField.text?.trimmingCharacters(in: .whitespaces),
              let trimmedEmail2 = emailTextField2.text?.trimmingCharacters(in: .whitespaces),
              trimmedEmail == trimmedEmail2 else{
            addCaution(title: Local.caution, message:Local.diffEmailCaution)
            return
        }
        passwordTextField.callText(){ string in
            let user = UserInfo(userName: userNameTextField.text, password: string, mail: emailTextField.text)
            viewModel.signUp(user)
        }
        
    }
}

//MARK: - Custom segment controller methods
extension SignUpMethodView:SignUpMethodViewModelDelegate{
    func handleOutput(_ output: SignUpMethodViewModelOutputs) {
        switch output {
        case .showAnyAlert(let caution):
          Animator.sharedInstance.hideAnimation()
            addCaution(title: Local.caution, message: caution)
        case .isLoading(let loading):
           loading ? Animator.sharedInstance.showAnimation() : Animator.sharedInstance.hideAnimation()
        case .signUpCompleted:
            signUpCompleted()
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
    
    private func signUpCompleted() {
        let alertView = UIAlertController(title: Local.registerSuccess, message: Local.verificationMailDes, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: Local.goBack, style: .default) {[unowned self] _ in
            navigationController?.popToRootViewController(animated: true)
        }
        alertView.addAction(alertAction)
        present(alertView, animated: true, completion: nil)
    }
}

extension SignUpMethodView:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextPagePreparation()
        textField.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        emailTextField2.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        userNameTextField.resignFirstResponder()
    }
}







