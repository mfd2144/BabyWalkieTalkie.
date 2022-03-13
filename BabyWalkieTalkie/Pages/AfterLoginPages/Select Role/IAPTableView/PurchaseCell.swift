//
//  PurchaseCell.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 14.02.2022.
//

import Foundation
import StoreKit

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
    var accessoryLogic: Bool = false
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
          if accessoryLogic{
              accessoryType = .checkmark
          }else{
              accessoryView = self.newBuyButton()
          }
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
      let buy = LocalAfterPages.buy
    button.setTitle(buy, for: .normal)
    button.addTarget(self, action: #selector(PurchaseCell.buyButtonTapped(_:)), for: .touchUpInside)
    button.sizeToFit()
    return button
  }
  
  @objc func buyButtonTapped(_ sender: AnyObject) {
    buyButtonHandler?(product!)
  }
}

