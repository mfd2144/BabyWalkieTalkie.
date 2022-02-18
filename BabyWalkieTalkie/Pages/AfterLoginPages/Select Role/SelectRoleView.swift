//
//  UserPageView.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 22.07.2021.
//

import UIKit

final class SelectRoleView:UICollectionViewController{
    //MARK: - ValueTypes
    typealias DataSource = UICollectionViewDiffableDataSource<SelectRoleSection,String>
    typealias SnapShot = NSDiffableDataSourceSnapshot<SelectRoleSection,String>
    
    
    //MARK: - Properties
    var viewModel: SelectRoleViewModelProtocol!
    var actionName:String?
    let roles = [Local_A.parent,Local_A.baby]
    
    let images = [UIImage(named: "parents")?.withRenderingMode(.alwaysOriginal),
                  UIImage(named: "baby")?.withRenderingMode(.alwaysOriginal)]
    lazy var dataSource = makeDataSource()
    lazy var settingsButton:UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settingsPressed))
        return button
    }()
    
    lazy var connectButton:UIBarButtonItem = {
        let button = UIBarButtonItem(title: Local_A.connect, style: .plain, target: self, action: #selector(pair))
        return button
    }()
    
    lazy var disconnectButton:UIBarButtonItem = {
        let button = UIBarButtonItem(title: Local_A.disconnect, style: .plain, target: self, action: #selector(separate))
        return button
    }()
    
    lazy var loadingButton:UIBarButtonItem = {
        let button = UIBarButtonItem(title: Local_A.loading, style: .plain, target: nil, action:nil)
        return button
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 0
        return stack
    }()
    
    let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = 2
        pc.currentPage = 0
        pc.currentPageIndicatorTintColor = MyColor.secondColor
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    let usageCaution:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    let inAppPurchaseButton: UIButton = {
        let button = UIButton.addNewButton(imageName: nil, title:Local_A.purchase)
        button.addShadow()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
}

extension SelectRoleView{
    //MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.collectionViewLayout = createLayout()
        setNavigationControllerproperties()
        viewModel.checkDidConnetionLostBefore()
        viewModel.checkDidPairBefore()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        applySnapshot()
        setSubviews()
        collectionView.alwaysBounceVertical = false
    }
    
    //MARK: - TableView Data Source
    func setCollectionView(){
        collectionView.backgroundColor = MyColor.myBlueColor
        collectionView.register(SelectCollectionCell.self, forCellWithReuseIdentifier: SelectCollectionCell.identifier)
        collectionView.register(SelectReusableView.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader , withReuseIdentifier: SelectReusableView.identifier)
    }
    
    func makeDataSource()->DataSource{
        let dataSource = DataSource(collectionView: collectionView) { [unowned self] collectionView, indexPath, roleName in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectCollectionCell.identifier, for: indexPath) as? SelectCollectionCell else {return UICollectionViewCell()}
            guard let image = images[indexPath.row] else {fatalError()}
            let cellName = roleName
            cell.setCell(cellName, image: image)
            return cell
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SelectReusableView.identifier, for: indexPath) as? SelectReusableView
            reusableView?.setLabel(Local_A.select)
            return reusableView
        }
        return dataSource
    }
    
    
    func applySnapshot(animated:Bool = true){
        var snapsot = SnapShot()
        snapsot.appendSections(SelectRoleSection.allCases)
        snapsot.appendItems(roles, toSection: .main)
        dataSource.apply(snapsot, animatingDifferences: animated, completion: nil)
    }
    
    func createLayout()->UICollectionViewCompositionalLayout{
        let layout = UICollectionViewCompositionalLayout(sectionProvider: {[unowned self] section, env in
            let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: size)
            item.contentInsets = .init(top: 0 , leading: buttonDistance, bottom: buttonDistance, trailing: buttonDistance)
            
            
            var floatAcordingtoScreen:CGFloat = 0
            switch self.view.frame.height{
            case 0..<700:floatAcordingtoScreen = 1.2
            case 700..<800:floatAcordingtoScreen = 1.3
            default:floatAcordingtoScreen = 1.5
            }
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(floatAcordingtoScreen))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            
            let headerAnchor = NSCollectionLayoutAnchor(edges: [.top],
                                                        absoluteOffset: CGPoint(x: 0, y: 0.3))
            let supplementarySize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: supplementarySize, elementKind: UICollectionView.elementKindSectionHeader,containerAnchor:headerAnchor)
            sectionHeader.pinToVisibleBounds = false
            sectionHeader.contentInsets = .init(top: 0, leading: buttonSize, bottom: 0, trailing: buttonSize)
            section.boundarySupplementaryItems = [sectionHeader]
            section.orthogonalScrollingBehavior = .paging
            section.visibleItemsInvalidationHandler = { [unowned self]items, offset, env in
                pageControl.currentPage = (items.last?.indexPath.row)!
            }
            return section
        })
        return layout
    }
    
    @objc private func babyImageTapped(){
        viewModel.toListenBaby()
    }
    
    @objc private func parentImageTapped(){
        viewModel.toParentControl()
    }
    
    
    //MARK: Collection View Delegate(Expand Transition)
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            viewModel.toParentControl()
        case 1:
            viewModel.toListenBaby()
        default:
            break
        }
    }
    
    //MARK: - Other Subviews
    
    func setSubviews(){
        stackView.addArrangedSubview(pageControl)
        stackView.addArrangedSubview(usageCaution)
        stackView.addArrangedSubview(inAppPurchaseButton)
        view.addSubview(stackView)
        
        let stackHeight = 3*buttonSize
        
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: (-1)*buttonDistance),
            stackView.heightAnchor.constraint(equalToConstant: stackHeight),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: buttonDistance),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: (-1)*buttonDistance)
        ])
        
        pageControl.addTarget(self, action: #selector(pageDidChange), for: .valueChanged)
        inAppPurchaseButton.addTarget(self, action: #selector(purchasedPressed), for: .touchUpInside)
        inAppPurchaseButton.isHidden = true
        usageCaution.isHidden = true
    }
    
    @objc private func pageDidChange(){
        let indexPath = IndexPath.init(row: pageControl.currentPage, section: 0)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    @objc private func purchasedPressed(){
        inAppPurchaseButton.pressAnimation()
        viewModel.toPurchase()
    }
    
    //MARK: - NavigationController
    private func setNavigationControllerproperties(){
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.rightBarButtonItem = settingsButton
        navigationItem.leftBarButtonItem = loadingButton
    }
    
    @objc private func settingsPressed(){
        let alertView = UIAlertController(title: Local_A.settings, message: nil, preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: Local_A.logOut, style: .default) { [unowned self] _ in
            logout()
        }
        let upgrade = UIAlertAction(title: actionName ?? Local_A.upgrade, style: .default) { [unowned self] _ in
            purchasedPressed()
        }
        
        let cancelAction = UIAlertAction(title: Local_A.cancel, style: .destructive, handler: nil)
        let actions = [logoutAction,upgrade,cancelAction]
        for action in actions{
            alertView.addAction(action)
        }
        present(alertView, animated: true, completion: nil )
    }
    
    private func logout(){
        let logoutAlert = LogOutAlert()
        logoutAlert.delegate = self
        present(logoutAlert, animated: true, completion: nil)
    }
    
    @objc private func separate(){
        let  alerView = UIAlertController(title: Local_A.disconnect, message:  Local_A.disconnectRequest, preferredStyle: .alert)
        let actionAccept = UIAlertAction(title: Local_A.disconnect, style: .default) { [unowned self] _ in
            viewModel.disconnectRequest()
        }
        let cancel = UIAlertAction(title: Local_A.cancel, style: .cancel, handler: nil)
        let actions = [actionAccept,cancel]
        actions.forEach({alerView.addAction($0)})
        present(alerView, animated: true, completion: nil)
    }
    
    @objc private func pair(){
        let  alerView = UIAlertController(title: Local_A.connect, message:nil , preferredStyle: .alert)
        let openConnection = UIAlertAction(title: Local_A.openChannel, style: .default) {[unowned self] _ in
            viewModel.openConnection()
        }
        
        let searchConnection = UIAlertAction(title: Local_A.searchChannel, style: .default) {[unowned self] _ in
            viewModel.searchForConnection()
        }
        
        let cancel = UIAlertAction(title: Local_A.cancel, style: .cancel, handler: nil)
        let actions = [openConnection,searchConnection,cancel]
        actions.forEach({alerView.addAction($0)})
        present(alerView, animated: true, completion: nil)
    }
}

extension SelectRoleView:SelectRoleViewModelDelegate{
    func invitationArrived(by: String) -> Bool {
        let alert = UIAlertController(title: Local_A.connecting, message: "Connecting to \(by)", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: Local_A.ok, style: .cancel, handler: nil)
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
            addCaution(title: "Alert", message: alert)
        case .showNearbyUser(let user):
            let alert = UIAlertController(title: Local_A.connecting, message: "Connecting to \(user)", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: Local_A.ok, style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        case .matchStatus(let status):
            DispatchQueue.main.async { [unowned self] in
                switch status {
                case .loading:
                    navigationItem.leftBarButtonItem = loadingButton
                case .connected:
                    navigationItem.leftBarButtonItem = disconnectButton
                case.error:
                    navigationItem.leftBarButtonItem = UIBarButtonItem(title: Local_A.error, style: .plain, target: nil, action: nil)
                case .readyToConnect:
                    navigationItem.leftBarButtonItem = connectButton
                }
            }
            
        case .remainingDay(let demoCondition):
            DispatchQueue.main.async {[unowned self] in
                inAppPurchaseButton.isHidden = false
                switch demoCondition {
                case .oneDay:
                    usageCaution.text = Local_A.oneDay
                    usageCaution.isHidden = false
                case .twoDays:
                    usageCaution.text = Local_A.twooDays
                    usageCaution.isHidden = false
                case .threeDays:
                    usageCaution.text = Local_A.threeDays
                    usageCaution.isHidden = false
                case .finished:
                    usageCaution.text = Local_A.daysFinished
                    usageCaution.isHidden = false
                    usageCaution.reloadShadow()
                case.alreadyMember:
                    printNew("already member")
                    inAppPurchaseButton.isHidden = true
                    usageCaution.isHidden = true
                }
                inAppPurchaseButton.isHidden = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.01){ [unowned self] in
                inAppPurchaseButton.reloadShadow()
                actionName = Local_A.buy
            }
            
        case .badConnection:
           let caution = AddAnySimpleCaution(title: Local_A.badConnection, message: Local_A.badConDefine, handler: nil)
            present(caution, animated: true)
        case .membershipCaution:
            let caution = AddAnySimpleCaution(title: Local_A.demoCaution, message: Local_A.demoCautionDefine, handler: nil)
             present(caution, animated: true)
        }
    }
    
}

extension SelectRoleView:LogOutAlertDelegate{
    func handleError(_ error: Error) {
        addCaution(title: Local_A.logOutError, message: Local_A.tryAgain)
    }
}




