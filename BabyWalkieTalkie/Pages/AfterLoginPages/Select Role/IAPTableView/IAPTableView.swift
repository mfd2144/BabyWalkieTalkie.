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
    private var audioLogic:Bool = false
    private var audioVideoLogic: Bool = false
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
                if self.helper.isProductPurchased(PurchaseType.videoAudio.rawValue){
                    self.audioVideoLogic = true
                }
            }
        }
    }
   
    let tableView: UITableView = {
        let table = UITableView()
        table.register(PurchaseCell.self, forCellReuseIdentifier: PurchaseCell.cellID)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = MyColor.green
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
        cell.accessoryLogic = audioVideoLogic
        cell.helper = helper
        cell.product = product
        if product.productIdentifier == PurchaseType.audio.rawValue && cell.accessoryType == .checkmark{
            audioLogic = true
        }
        if (audioVideoLogic || audioLogic) && product.productIdentifier == PurchaseType.videoAudio.rawValue{
            cell.product = products[indexPath.row+1]
        }
        cell.buyButtonHandler = { [unowned self] product in
          helper.buyProduct(product)
            self.dismiss(animated: true, completion: nil)
        }
        return cell
    }
}

