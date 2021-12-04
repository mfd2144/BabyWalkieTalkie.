//
//  FirstPageView.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 12.07.2021.
//

import UIKit



final class FirstPageView:UIViewController,FirstPageViewModelDelegate{
    var model :FirstPageViewModelProtocol!
    
    private let appName :UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "Cookie-Regular", size: 70)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.text = Local.appName
        label.textAlignment = .center
        return label
    }()
    
    private let emptyLabel :UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let newAccountButton:UIButton = {
        let title = Local.create
        let button = UIButton.addNewButton(imageName: nil, title: title)
        return button
    }()
    
    private let loginButton:UIButton = {
        let title = Local.logIn
        let button = UIButton.addNewButton(imageName: nil, title: title)
        return button
    }()
    
    let stack:UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        return stackView
    }()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MyColor.myBlueColor
        setStack()
        addButtonTarget()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    override func viewDidLayoutSubviews() {
        loginButton.reloadShadow()
        newAccountButton.reloadShadow()
    }
    
    
//MARK: - Set StackView
    private func setStack(){
        
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
        
        let views = [appName, emptyLabel, newAccountButton, loginButton ]
        for _view in views{
            stack.addArrangedSubview(_view)
        }
        view.addSubview(stack)
        
  
        stack.putSubviewAt(top: nil, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, topDis: 0, bottomDis: -60, leadingDis: buttonDistance, trailingDis: buttonDistance*(-1), heightFloat: UIScreen.main.bounds.height/1.3, widthFloat: nil, heightDimension: nil, widthDimension: nil)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: buttonSize),
            newAccountButton.heightAnchor.constraint(equalToConstant: buttonSize)])
        stack.spacing = buttonDistance
        
    }
     
    
    
    private func setSubviewsForPads(){

        let views = [appName, emptyLabel, newAccountButton, loginButton ]
        for _view in views{
            stack.addArrangedSubview(_view)
        }
        view.addSubview(stack)
        
        stack.putSubviewAt(top: nil, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, topDis: 0, bottomDis: 0, leadingDis: 200, trailingDis: -200, heightFloat: UIScreen.main.bounds.height/3, widthFloat: nil, heightDimension: nil, widthDimension: nil)
        NSLayoutConstraint.activate([
                                        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
    }
    
    
    //MARK: - Add  buttons' target and function
    private func addButtonTarget(){
        newAccountButton.addTarget(self, action: #selector(newAccountPushed), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(logInPushed), for: .touchUpInside)
    }
    
    @objc private func newAccountPushed(){
        model.goToPage(.createNewUserPage)
    }
    

    @objc private func  logInPushed(){
        model.goToPage(.logIn)
    }
    
}




