//
//  ForgotThePasswordView.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 19.07.2021.
//

import UIKit
import FBSDKLoginKit


final class ForgotThePasswordView:UIViewController{
    var model:ForgotThePasswordViewModelProtocol!
    
    let lockImage:UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "lock.circle")?.withRenderingMode(.alwaysOriginal).applyingSymbolConfiguration(.init(weight: .ultraLight))
        imageView.image = image
        image?.withTintColor(.black)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text =  Local.trouble
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = Local.troubleDescription
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return label
    }()
  
    lazy var textField:UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.layer.cornerRadius = 10
        field.textColor = .black
        field.backgroundColor = MyColor.buttonColor
        field.keyboardType = .emailAddress
        let phString = Local.emailPlaceHolder
        field.attributedPlaceholder = NSAttributedString.init(string: phString, attributes: [NSAttributedString.Key.foregroundColor:UIColor.gray,NSAttributedString.Key.font:UIFont.preferredFont(forTextStyle: .title3)])
        field.font = UIFont.preferredFont(forTextStyle: .title3)
        field.setRightPaddingPoints(20)
        field.setLeftPaddingPoints(20)
        return field
    }()
    
    let topStackView:UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let bottomStackView_top:UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let bottomStackView_down:UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let nextButton:UIButton = {
        let title = Local.sendLink
        let button = UIButton.addNewButton(imageName: nil, title: title)
        return button
    }()
    
    let orLabel:UILabel = {
        let label = UILabel()
        label.text = Local.or
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
    
    let authorizationButton: UIButton = {
        let button = UIButton.addNewButton(imageName: "applelogo", title: Local.apple)
        return button
  }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setTitle(Local.back, for: .normal)
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
        return stack
    }()
    //MARK: - Life cycle
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        textField.delegate = self
        setSubviews()
        setTargets()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        nextButton.reloadShadow()
        fBButton.reloadShadow()
        googleButton.reloadShadow()
        authorizationButton.reloadShadow()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransition(to: size, with: coordinator)
            if UIDevice.current.orientation.isLandscape {
                textField.resignFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        }
    
    //MARK: - Set subviews
    
    private func setSubviews(){
        let topstackViews = [lockImage,titleLabel,descriptionLabel]
        for view in topstackViews{
            topStackView.addArrangedSubview(view)
        }
        let stackViews_top = [textField,nextButton]
        let stackViews_down = [authorizationButton, googleButton,fBButton]
        for view in stackViews_top{
            bottomStackView_top.addArrangedSubview(view)
        }
        for view in stackViews_down{
            bottomStackView_down.addArrangedSubview(view)
        }
        bottomStackView_down.spacing = buttonDistance
        bottomStackView_top.spacing = buttonDistance
        bottomStack.addArrangedSubview(backButton)
        view.addSubview(topStackView)
        view.addSubview(bottomStackView_top)
        view.addSubview(orLabel)
        view.addSubview(bottomStackView_down)
        view.addSubview(bottomStack)
        let downStackHeight = 3*buttonSize+2*buttonDistance
        let topStackHeight = 2*buttonSize+buttonDistance
        
        NSLayoutConstraint.activate([
            bottomStack.heightAnchor.constraint(equalToConstant: buttonSize),
            bottomStackView_top.heightAnchor.constraint(equalToConstant: topStackHeight),
            bottomStackView_down.heightAnchor.constraint(equalToConstant: downStackHeight),
            bottomStackView_top.bottomAnchor.constraint(equalTo: orLabel.topAnchor),
            orLabel.heightAnchor.constraint(equalToConstant:buttonSize),
            orLabel.bottomAnchor.constraint(equalTo: bottomStackView_down.topAnchor),
            bottomStackView_down.bottomAnchor.constraint(equalTo:bottomStack.topAnchor,constant:  buttonDistance*(-1) ),
            lockImage.heightAnchor.constraint(equalTo: topStackView.heightAnchor, multiplier: 0.5),
            titleLabel.heightAnchor.constraint(equalTo: topStackView.heightAnchor, multiplier: 0.25),
            descriptionLabel.heightAnchor.constraint(equalTo: topStackView.heightAnchor, multiplier: 0.25),
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
        
        NSLayoutConstraint.activate([
            bottomStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -1*buttonDistance),
            bottomStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomStack.widthAnchor.constraint(equalTo: view.widthAnchor),
            topStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant:buttonDistance),
            topStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: buttonDistance),
            topStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: buttonDistance*(-1)),
            topStackView.bottomAnchor.constraint(equalTo: bottomStackView_top.topAnchor,constant: -1*buttonDistance),
            bottomStackView_top.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: buttonDistance),
            bottomStackView_top.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: buttonDistance*(-1)),
            bottomStackView_down.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: buttonDistance),
            bottomStackView_down.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: buttonDistance*(-1)),
            topStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: buttonDistance),
            topStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: buttonDistance*(-1)),
            orLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: buttonDistance),
            orLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: buttonDistance*(-1)),
        ])
    }
    
    private func setSubviewsForPads(){
        NSLayoutConstraint.activate([
            bottomStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -1*buttonSize),
            orLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            orLabel.widthAnchor.constraint(equalToConstant: screenWidth-300),
            bottomStackView_top.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomStackView_top.widthAnchor.constraint(equalToConstant: screenWidth-300),
            bottomStackView_down.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomStackView_down.widthAnchor.constraint(equalToConstant: screenWidth-300),
            topStackView.heightAnchor.constraint(equalToConstant: 200),
            topStackView.bottomAnchor.constraint(equalTo: bottomStackView_top.topAnchor, constant: -1*buttonSize),
            topStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topStackView.widthAnchor.constraint(equalToConstant: screenWidth-300),
            bottomStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomStack.widthAnchor.constraint(equalToConstant: screenWidth-300),
        ])
    }
   
    //MARK: - Add button target
    private func setTargets(){
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        backButton.addTarget(self, action:#selector(backButtonPressed), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googlePressed), for: .touchUpInside)
        fBButton.addTarget(self, action: #selector(getFacebookUserInfo), for: .touchUpInside)
        authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest(_ :)), for: .touchUpInside)
       
    }
    
    @objc private func nextButtonPressed(){
        nextButton.pressAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.15) { [unowned self] in
            textField.endEditing(true)
            model.sendPasswordReset(email: textField.text!)
        }
    }
    
    @objc private func backButtonPressed(_ sender: UIButton){
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func googlePressed(){
        googleButton.pressAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.15) { [unowned self] in
            model.googlePressed()
        }
    }
    @objc private func handleAppleIdRequest(_ sender:UIButton) {
        authorizationButton.pressAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.15) { [unowned self] in
            model.appleButtonPressed()
        }
        
    }
    
    @objc func getFacebookUserInfo(){
        fBButton.pressAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.15) { [unowned self] in
            model.fbButtonPressed()
        }
    }
}

//MARK: - Outputs of model
extension ForgotThePasswordView:ForgotThePasswordViewModelDelegate{
    func handleOutput(_ output: ForgotThePasswordViewModelOutputs) {
        switch output {
        case .loggedIn(let response):
            switch response {
            case .failure(let error ):
                guard let error = error as?  FirebaseError else {return}
                addCaution(title: Local.error, message:error.description )
            default:
               break
            }
            
        case .isLoading(let loading):
            loading ? Animator.sharedInstance.showAnimation() : Animator.sharedInstance.hideAnimation()
        case.showAnyAlert(let caution):
            Animator.sharedInstance.hideAnimation()
            let alert = UIAlertController(title: Local.caution, message: caution, preferredStyle: .alert)
            let action = UIAlertAction(title: Local.ok, style: .cancel) { _ in
                if caution == FirebaseLocal.tryOtherWay{
                    appContainer.authService.signOut()
                }
            }
            alert.addAction(action)
            present(alert, animated: true)
        case .verificationCodeSend:
            let alertController = UIAlertController(title: Local.caution, message: Local.sentMessage, preferredStyle: .alert)
            let action = UIAlertAction(title: Local.ok, style: .cancel){ [unowned self] _ in
                navigationController?.popViewController(animated: true)
            }
            alertController.addAction(action)
            present(alertController, animated: true)
        }
    }
}

extension ForgotThePasswordView:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextButtonPressed()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
    }
}










