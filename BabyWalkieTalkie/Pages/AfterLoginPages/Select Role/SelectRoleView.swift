//
//  UserPageView.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 22.07.2021.
//

import UIKit


final class SelectRoleView:UIViewController{
    
    var transationView:TransionView = {
        let view = TransionView(frame: UIScreen.main.bounds)
        view.layer.zPosition = 999
        return view
    }()
    //MARK: - Properties
    var viewModel: SelectRoleViewModelProtocol!
    var actionName:String?
    var startingSequence:Bool = true
    let roles = [LocalAfterPages.parent,LocalAfterPages.baby]
    let images = [UIImage(named: "mother_1")?.withRenderingMode(.alwaysOriginal).withTintColor(MyColor.pink),
                  UIImage(named: "baby_1")?.withRenderingMode(.alwaysOriginal).withTintColor(MyColor.pink)]
    var bottomStackConstraint:NSLayoutConstraint!
    var bottomPurchaseConstraint:NSLayoutConstraint!
    lazy var settingsButton:UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settingsPressed))
        return button
    }()
    
    var loadingLogic: Bool = false
    
    lazy var connectButton:UIBarButtonItem = {
        let button = UIBarButtonItem(title: LocalAfterPages.connect, style: .plain, target: self, action: #selector(pair))
        return button
    }()
    
    lazy var disconnectButton:UIBarButtonItem = {
        let button = UIBarButtonItem(title: LocalAfterPages.disconnect, style: .plain, target: self, action: #selector(separate))
        return button
    }()
    
    lazy var loadingButton:UIBarButtonItem = {
        let button = UIBarButtonItem(title: LocalAfterPages.loading, style: .plain, target: nil, action:nil)
        return button
    }()
    
    var selectLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.text = LocalAfterPages.select
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.spacing = buttonSize
        return stack
    }()
    
    let babyWTView:UIStackView = {
        let view = UIStackView()
        view.spacing = 0
        view.alignment = .fill
        view.distribution = .fill
        view.axis = .vertical
        return view
    }()
    
    lazy var babyImage:UIImageView = {
        let imageV = UIImageView()
        imageV.image = images.last!
        imageV.contentMode = .scaleAspectFit
        return imageV
    }()
    
    let babyButton: UIButton = {
        let button = UIButton.addNewButton(imageName: nil, title: LocalAfterPages.baby)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let parentWTView:UIStackView = {
        let view = UIStackView()
        view.alignment = .fill
        view.spacing = 0
        view.distribution = .fill
        view.axis = .vertical
        return view
    }()
    
    let parentButton: UIButton = {
        let button = UIButton.addNewButton(imageName: nil, title: LocalAfterPages.parent)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var parentImage:UIImageView = {
        let imageV = UIImageView()
        imageV.image = images.first!
        imageV.contentMode = .scaleAspectFit
        return imageV
    }()
    
    let purchaseView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        view.addShadow()
        return view
    }()
    
    let purchaseLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    let inAppPurchaseButton: UIButton = {
        let button = UIButton.addNewButton(imageName: nil, title:LocalAfterPages.purchase)
        button.addShadow()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}

extension SelectRoleView{
    //MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.checkDidConnetionLostBefore()
        viewModel.checkDidPairBefore()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(transationView)
        view.backgroundColor = .white
        setTargets()
        setSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        purchaseView.reloadShadow()
        babyButton.addShadow()
        parentButton.addShadow()
    }
    
    //MARK: - Other Subviews
    
    func setSubviews(){
        view.addSubview(selectLabel)
        stackView.addArrangedSubview(babyWTView)
        stackView.addArrangedSubview(parentWTView)
        stackView.addArrangedSubview(purchaseView)
        babyWTView.addArrangedSubview(babyImage)
        babyWTView.addArrangedSubview(babyButton)
        parentWTView.addArrangedSubview(parentImage)
        parentWTView.addArrangedSubview(parentButton)
        view.addSubview(stackView)
        purchaseView.addSubview(purchaseLabel)
        purchaseView.addSubview(inAppPurchaseButton)
    
        NSLayoutConstraint.activate([
                        selectLabel.heightAnchor.constraint(equalToConstant: buttonSize),
                        selectLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: buttonDistance),
                        selectLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: (-1)*buttonDistance),
                        selectLabel.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor),
                        stackView.topAnchor.constraint(equalTo:selectLabel.bottomAnchor,constant: buttonSize),
                        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -1*buttonSize),
                        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: buttonDistance),
                        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: (-1)*buttonDistance),
                        parentButton.heightAnchor.constraint(equalToConstant: buttonSize),
                        babyButton.heightAnchor.constraint(equalToConstant: buttonSize),
                        purchaseLabel.leadingAnchor.constraint(equalTo: purchaseView.leadingAnchor,constant: buttonDistance),
                        purchaseLabel.heightAnchor.constraint(equalToConstant: buttonSize),
                        purchaseLabel.topAnchor.constraint(equalTo: purchaseView.topAnchor,constant: buttonDistance),
                        purchaseLabel.trailingAnchor.constraint(equalTo: purchaseView.trailingAnchor),
                        inAppPurchaseButton.heightAnchor.constraint(equalToConstant: buttonSize),
                        inAppPurchaseButton.bottomAnchor.constraint(equalTo:purchaseView.bottomAnchor,constant: -1*buttonDistance),
                        inAppPurchaseButton.trailingAnchor.constraint(equalTo: purchaseView.trailingAnchor,constant: -1*buttonDistance),
                        inAppPurchaseButton.widthAnchor.constraint(equalTo: purchaseView.widthAnchor, multiplier: 0.5)
        ])
        
    }
    
    
    
    //MARK: - Functions
    private func setTargets(){
        inAppPurchaseButton.addTarget(self, action: #selector(purchasedPressed), for: .touchUpInside)
        babyButton.addTarget(self, action: #selector(babyImageTapped), for: .touchUpInside)
        parentButton.addTarget(self, action: #selector(parentImageTapped), for: .touchUpInside)
    }
    
    @objc private func purchasedPressed(){
        inAppPurchaseButton.pressAnimation()
       viewModel.toPurchase()
        startingSequence = false
    }
    
    @objc private func babyImageTapped(){
        viewModel.toListenBaby()
    }
    
    @objc private func parentImageTapped(){
        viewModel.toParentControl()
    }
    
    //MARK: - NavigationController
    private func setNavigationControllerproperties(){
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.rightBarButtonItem = settingsButton
        loadingLogic = true
    }
    
    @objc private func settingsPressed(){
        let alertView = UIAlertController(title: LocalAfterPages.settings, message: nil, preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: LocalAfterPages.logOut, style: .default) { [unowned self] _ in
            logout()
        }
        let upgrade = UIAlertAction(title: actionName ?? LocalAfterPages.upgrade, style: .default) { [unowned self] _ in
            viewModel.toPurchase()
            startingSequence = false
        }
        
        let cancelAction = UIAlertAction(title: LocalAfterPages.cancel, style: .destructive, handler: nil)
        let actions = [logoutAction,upgrade,cancelAction]
        for action in actions{
            alertView.addAction(action)
        }
        let xOrigin = self.view.bounds.width / 2
        let popoverRect = CGRect(x: xOrigin, y: 0, width: 1, height: 1)
        alertView.popoverPresentationController?.sourceView = self.view
        alertView.popoverPresentationController?.sourceRect = popoverRect
        alertView.popoverPresentationController?.permittedArrowDirections = .up
        present(alertView, animated: true, completion: nil )
    }
    
    private func logout(){
        let logoutAlert = LogOutAlert()
        logoutAlert.delegate = self
        let xOrigin = self.view.bounds.width / 2
        let popoverRect = CGRect(x: xOrigin, y: 0, width: 1, height: 1)
        logoutAlert.popoverPresentationController?.sourceView = self.view
        logoutAlert.popoverPresentationController?.sourceRect = popoverRect
        logoutAlert.popoverPresentationController?.permittedArrowDirections = .up
        present(logoutAlert, animated: true, completion: nil)
    }
    
    @objc private func separate(){
        let  alerView = UIAlertController(title: LocalAfterPages.disconnect, message:  LocalAfterPages.disconnectRequest, preferredStyle: .alert)
        let actionAccept = UIAlertAction(title: LocalAfterPages.disconnect, style: .default) { [unowned self] _ in
            viewModel.disconnectRequest()
        }
        let cancel = UIAlertAction(title: LocalAfterPages.cancel, style: .cancel, handler: nil)
        let actions = [actionAccept,cancel]
        actions.forEach({alerView.addAction($0)})
        present(alerView, animated: true, completion: nil)
    }
    
    @objc private func pair(){
        let  alerView = UIAlertController(title: LocalAfterPages.connect, message:nil , preferredStyle: .alert)
        let openConnection = UIAlertAction(title: LocalAfterPages.openChannel, style: .default) {[unowned self] _ in
            viewModel.openConnection()
        }
        
        let searchConnection = UIAlertAction(title: LocalAfterPages.searchChannel, style: .default) {[unowned self] _ in
            viewModel.searchForConnection()
        }
        
        let cancel = UIAlertAction(title: LocalAfterPages.cancel, style: .cancel, handler: nil)
        let actions = [openConnection,searchConnection,cancel]
        actions.forEach({alerView.addAction($0)})
        present(alerView, animated: true, completion: nil)
    }
}
//MARK: -View Model Delegate
extension SelectRoleView:SelectRoleViewModelDelegate{
    func invitationArrived(by: String) -> Bool {
        let alert = UIAlertController(title: LocalAfterPages.connecting, message: LocalAfterPages.connectTo + " \(by)" , preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: LocalAfterPages.ok, style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        return true
    }
    
    func handleOutputs(_ output: SelectRoleViewModelOutputs) {
        switch  output {
        case .isLoading(let loading):
            DispatchQueue.main.async{
                loading ? Animator.sharedInstance.showAnimation() : Animator.sharedInstance.hideAnimation()
            }
        case .showAnyAlert(let alert):
            addCaution(title: LocalAfterPages.alert, message: alert)
        case .showNearbyUser(let user):
            let alert = UIAlertController(title: LocalAfterPages.connecting, message: LocalAfterPages.connectTo + " \(user)" , preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: LocalAfterPages.ok, style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        case .matchStatus(let status):
            DispatchQueue.main.async { [unowned self] in
                switch status {
                case .loading:
                    navigationItem.leftBarButtonItem = loadingButton
                    loadingLogic = true
                case .connected:
                    navigationItem.leftBarButtonItem = disconnectButton
                    loadingLogic = false
                case.error:
                    loadingLogic = false
                    navigationItem.leftBarButtonItem = UIBarButtonItem(title: LocalAfterPages.error, style: .plain, target: nil, action: nil)
                case .readyToConnect:
                    loadingLogic = false
                    navigationItem.leftBarButtonItem = connectButton
                }
            }
            
        case .remainingDay(let demoCondition):
            transationView.removeFromSuperview()
            DispatchQueue.main.async {[unowned self] in
                setNavigationControllerproperties()
                switch demoCondition {
                case .oneDay:
                    purchaseLabel.text = LocalAfterPages.oneDay
                    inAppPurchaseButton.setTitle(LocalAfterPages.purchase, for: .normal)
                    inAppPurchaseButton.reloadShadow()
                case .twoDays:
                    purchaseLabel.text = LocalAfterPages.twooDays
                    inAppPurchaseButton.setTitle(LocalAfterPages.purchase, for: .normal)
                    inAppPurchaseButton.reloadShadow()
                case .threeDays:
                    purchaseLabel.text = LocalAfterPages.threeDays
                    inAppPurchaseButton.setTitle(LocalAfterPages.purchase, for: .normal)
                    inAppPurchaseButton.reloadShadow()
                case .finished:
                    purchaseLabel.text = LocalAfterPages.daysFinished
                    inAppPurchaseButton.setTitle(LocalAfterPages.purchase, for: .normal)
                    inAppPurchaseButton.reloadShadow()
                case.alreadyMember:
                    if startingSequence{
                        purchaseView.removeFromSuperview()
                        startingSequence = false
                    }else {
                        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut) { [unowned self] in
                            inAppPurchaseButton.removeFromSuperview()
                            purchaseView.isHidden = true
                        } completion: { _ in
                            purchaseView.removeFromSuperview()
                        }
                       
                    }
                }
                
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.01){ [unowned self] in
                inAppPurchaseButton.reloadShadow()
                actionName = LocalAfterPages.buy
            }
            
        case .badConnection:
            let caution = AddAnySimpleCaution(title: LocalAfterPages.badConnection, message: LocalAfterPages.badConDefine, handler: nil)
            present(caution, animated: true)
        case .membershipCaution:
            let caution = AddAnySimpleCaution(title: LocalAfterPages.demoCaution, message: LocalAfterPages.demoCautionDefine, handler: nil)
            present(caution, animated: true)
        case .sameUser:
            DispatchQueue.main.async {[unowned self] in
                guard let alert = (appContainer.router.window?.rootViewController as? UINavigationController)?.visibleViewController as? UIAlertController else {return}
                alert.dismiss(animated: true) {
                    let caution = AddAnySimpleCaution(title: "Caution", message: "Must be different account", handler: nil)
                    present(caution, animated: true, completion: nil)
                }
            }
          
            
           
        }
    }
    
}

extension SelectRoleView:LogOutAlertDelegate{
    func handleError(_ error: Error) {
        addCaution(title: LocalAfterPages.logOutError, message: LocalAfterPages.tryAgain)
    }
}


extension LocalAfterPages{
    static let connectTo = NSLocalizedString("ConnectTo", comment: "")
}

