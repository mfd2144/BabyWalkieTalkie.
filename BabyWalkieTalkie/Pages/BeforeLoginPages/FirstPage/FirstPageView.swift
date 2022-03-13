//
//  FirstPageView.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 12.07.2021.
//

import UIKit



final class FirstPageView:UIViewController,FirstPageViewModelDelegate{
    var model :FirstPageViewModelProtocol!
    
    private let appIcon: UIImageView = {
        let iView = UIImageView()
        iView.image = UIImage(named: "icon")
        iView.contentMode = .scaleAspectFit
        iView.translatesAutoresizingMaskIntoConstraints = false
        return iView
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
        stackView.distribution = .fill
        stackView.axis = .vertical
        return stackView
    }()
    
    //MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginButton.reloadShadow()
        newAccountButton.reloadShadow()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
        
        let views = [appIcon, emptyLabel, newAccountButton, loginButton ]
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
      
        let views = [appIcon, emptyLabel, newAccountButton, loginButton ]
        for _view in views{
            stack.addArrangedSubview(_view)
        }
        view.addSubview(stack)
        
        stack.putSubviewAt(top: nil, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, topDis: 0, bottomDis: 0, leadingDis: 200, trailingDis: -200, heightFloat: UIScreen.main.bounds.height/2, widthFloat: nil, heightDimension: nil, widthDimension: nil)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        stack.spacing = buttonSize
    }
    
    
    //MARK: - Add  buttons' target and function
    private func addButtonTarget(){
        newAccountButton.addTarget(self, action: #selector(newAccountPushed), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(logInPushed), for: .touchUpInside)
    }
    
    @objc private func newAccountPushed(){
        newAccountButton.pressAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.15) { [unowned self] in
            model.goToPage(.createNewUserPage)
        }
        
    }
    
    @objc private func  logInPushed(){
        loginButton.pressAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.15) { [unowned self] in
            model.goToPage(.logIn)
        }
    }
}




