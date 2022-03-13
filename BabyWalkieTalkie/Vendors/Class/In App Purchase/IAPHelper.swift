//
//  Shopper.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 31.10.2021.
//

import Foundation
import StoreKit

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void

final class IAPHelper:NSObject{
    private let productIdentifiers: Set<ProductIdentifier>
    private var purchasedProductIdentifiers: Set<ProductIdentifier> = []
    private var productsRequest: SKProductsRequest?
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    var firebasePurchase = FirebasePaymentService()
    weak var delegate:IAPHelperDelegate?{
        didSet{
            getReceipt()
        }
    }
    
    public init(productIds: Set<ProductIdentifier>) {
        productIdentifiers = productIds
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    private func getReceipt(){
        firebasePurchase.getPayment { [unowned self]result  in
            switch result{
            case .failure(let error):
                guard let error = error as? PaymentError  else { return }
                delegate?.throwError(error: error.localErrorDescription)
                
            case.success(let purchasedItems):
                guard let purchasedItems = purchasedItems else {delegate?.loadProduct();return}
                let items = purchasedItems.items
                    for item in items {
                        print(item.name)
                        purchasedProductIdentifiers.insert(item.name)
                    }
                delegate?.loadProduct()
            }
        }
    }
    
    private func setReceipt(_ id:String,_ productIdentifier:String){
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
           FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
            var receiptString:String?
            do {
                let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                receiptString = receiptData.base64EncodedString(options: [])
            }
            catch {
                delegate?.throwError(error: IAPLocal.savingError)
                return
            }
            let requestContents = ["receipt-data" : receiptString,
                                   "exclude-old-transactions":true,
                                   "password":"7337156e308645ff86b89af5781c2fb8"] as [String : Any]
            let requestData = try? JSONSerialization.data(withJSONObject: requestContents, options: [])
            let serverURL = "https://sandbox.itunes.apple.com/verifyReceipt" // TODO:change this in production with https://buy.itunes.apple.com/verifyReceipt
            let url = NSURL(string: serverURL)
            let request = NSMutableURLRequest(url: url! as URL)
            request.httpMethod = "POST"
            request.httpBody = requestData
            let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { [unowned self]data, response, error -> Void in
                guard let data = data, error == nil else {
                    delegate?.throwError(error: IAPLocal.savingError)
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any]
                    if let receipt = json?["receipt"] as? [String: AnyObject],
                       let inApp = receipt["in_app"] as? [AnyObject] {
                        inApp.forEach({
                            if let transactionID = $0["transaction_id"] as? String,transactionID == id{
                                guard let dateString = $0["original_purchase_date"] as? String,
                                      let purchaseKind = $0["product_id"] as? String else {
                                          delegate?.throwError(error:IAPLocal.savingError)
                                          return}
                                let item = PurchasedItem(name: purchaseKind, date: dateString, transactionID: transactionID)
                                firebasePurchase.setPayment(item) { result in
                                    switch result{
                                    case .success:
                                        UserDefaults.standard.set(nil, forKey: "personWillSaveToDb")
                                        purchasedProductIdentifiers.insert(purchaseKind)
                                        delegate?.loadProduct()
                                    case .failure(let error):
                                        guard let error = error as? PaymentError  else { return }
                                        delegate?.throwError(error: error.localErrorDescription)
                                    }
                                }
                            }else{
                                //if any error occured,app would save transcation id and try save purchase information again to db
                                delegate?.throwError(error:IAPLocal.savingError)
                                return
                            }
                        })
                    }else{
                        delegate?.throwError(error: IAPLocal.savingError)
                        return
                    }
                }catch {
                    delegate?.throwError(error: IAPLocal.savingError)
                    return
                }
            })
            task.resume()
        }else{
            delegate?.throwError(error: IAPLocal.savingError)
            return
        }
    }
    private func savingError(_ id:String,_ productIdentifier:String){
        let dateFormatter = DateFormatter()
        let timezone = TimeZone.init(identifier: "Etc/GMT")
        dateFormatter.timeZone = timezone
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let now = Date()
        var date = dateFormatter.string(from: now)
        date = date+" Etc/GMT"
        let purchaseItem = PurchasedItem(name: productIdentifier, date: date, transactionID: id)
       let service = appContainer.authService
        guard let user = service.getUserdNameAndId() else {fatalError() }
        let savedItem = SavedPurchaseItem.init(userID: user.ID, item: purchaseItem)
        let data = SavedPurchaseItem.itemToData(item: savedItem)
        UserDefaults.standard.set(data, forKey: "personWillSaveToDb")
    }
}

extension IAPHelper {
    public func requestProducts(_ completionHandler: @escaping ProductsRequestCompletionHandler) {
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest!.delegate = self
        productsRequest!.start()
    }
    
    public func buyProduct(_ product: SKProduct) {
        FirebasePaymentService.setOldPayment{_ in
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }
    }
    
    public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
        return purchasedProductIdentifiers.contains(productIdentifier)
    }
    
    public class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
}

extension IAPHelper: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products.sorted(by: {$0.localizedTitle<$1.localizedTitle})
        productsRequestCompletionHandler?(true, products)
        clearRequestAndHandler()
    }
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        productsRequestCompletionHandler?(false, nil)
        clearRequestAndHandler()
    }
    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
}
extension IAPHelper: SKPaymentTransactionObserver {
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                guard let transactionID = transaction.transactionIdentifier else {return}
                firebasePurchase.checkTransactionDidSavedBefore(transactionID) { [unowned self] result in
                    switch result{
                    case.failure:
                        delegate?.throwError(error: IAPLocal.checkTransactionError)
                        break
                    case .success(let transactionCondition):
                        guard let transactionCondition = transactionCondition else {return}
                        switch transactionCondition {
                        case.notSaved:
                            complete(transaction: transaction)
                        default:
                            break
                        }
                    }
                }
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            default:
                break
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        let productIdentifier = transaction.payment.productIdentifier
        guard let identifier = transaction.transactionIdentifier else {
            savingError(UUID().uuidString, productIdentifier)
            return
        }
        savingError(identifier, productIdentifier)
            deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
            SKPaymentQueue.default().finishTransaction(transaction)
            setReceipt(identifier,productIdentifier)
        
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        deliverPurchaseNotificationFor(identifier: productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        if let transactionError = transaction.error as NSError?,
           let localizedDescription = transaction.error?.localizedDescription,
           transactionError.code != SKError.paymentCancelled.rawValue {
            delegate?.throwError(error: localizedDescription)
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func deliverPurchaseNotificationFor(identifier: String?) {
        guard let identifier = identifier else { return }
        purchasedProductIdentifiers.insert(identifier)
        UserDefaults.standard.set(true, forKey: identifier)
        NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: identifier)
    }
}




