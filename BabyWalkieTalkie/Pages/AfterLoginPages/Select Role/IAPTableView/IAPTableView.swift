//
//  IAPTableView.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 21.11.2021.
//

import Foundation
import UIKit
import StoreKit



final class IAPTableView:UIViewController{
    var products:[SKProduct] = []
    
    var helper:IAPHelper!{
        didSet{
            helper.requestProducts {[weak self] success, _products in
                guard let self = self,
                let _products = _products else { return }
                if success {
                    self.products = _products
                    DispatchQueue.main.async {
                        self.setTableView()
                    }
                }
            }
        }
    }
   
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(PurchaseCell.self, forCellReuseIdentifier: PurchaseCell.cellID)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = MyColor.myBlueColor
        table.allowsSelection = false
        table.isScrollEnabled = false
        table.rowHeight = 70
        table.layer.cornerRadius = 20
        return table
    }()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
    
    private func setTableView(){
        view.addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        
        let constraints:Array<NSLayoutConstraint> = [
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 140),
            tableView.widthAnchor.constraint(equalToConstant: view.frame.width-2*buttonDistance)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
}

extension IAPTableView:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PurchaseCell.cellID, for: indexPath) as? PurchaseCell else {return UITableViewCell()}
        let product = products[indexPath.row]
        cell.helper = helper
        cell.product = product
        cell.buyButtonHandler = { [unowned self] product in
          helper.buyProduct(product)
        }

        return cell
    }
   
}

class PurchaseCell: UITableViewCell {
    static let cellID = "PurchaseCell"
    var helper:IAPHelper!
    
  static let priceFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.formatterBehavior = .behavior10_4
    formatter.numberStyle = .currency
    return formatter
  }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier:PurchaseCell.cellID )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  var buyButtonHandler: ((_ product: SKProduct) -> Void)?
  
  var product: SKProduct? {
    didSet {
      guard let product = product else { return }

      textLabel?.text = product.localizedTitle

      if helper.isProductPurchased(product.productIdentifier) {
        accessoryType = .checkmark
        accessoryView = nil
        detailTextLabel?.text = ""
      } else if IAPHelper.canMakePayments() {
          PurchaseCell.priceFormatter.locale = product.priceLocale
        detailTextLabel?.text = PurchaseCell.priceFormatter.string(from: product.price)
        accessoryType = .none
        accessoryView = self.newBuyButton()
      } else {
        detailTextLabel?.text = "Not available"
      }
    }
  }
    
    func addBorder(){
        layer.addBorder(edge: .bottom, color: .gray, thickness: 1)
    }
    
  override func prepareForReuse() {
    super.prepareForReuse()
    textLabel?.text = ""
    detailTextLabel?.text = ""
    accessoryView = nil
  }
  
  func newBuyButton() -> UIButton {
    let button = UIButton(type: .system)
    button.setTitleColor(tintColor, for: .normal)
      let buy = Local_A.buy
    button.setTitle(buy, for: .normal)
    button.addTarget(self, action: #selector(PurchaseCell.buyButtonTapped(_:)), for: .touchUpInside)
    button.sizeToFit()
    
    return button
  }
  
  @objc func buyButtonTapped(_ sender: AnyObject) {
    buyButtonHandler?(product!)
  }
}

