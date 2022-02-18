//
//  Shopper.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 31.10.2021.
//

import Foundation
import StoreKit

protocol IAPHelperDelegate:AnyObject{
    func loadProduct()
    func errorBeforeTransactionSave(_ transactionID: String)
    func busy()
    func purchaseCompleted()
}

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
        checkReceipt()
    }
    
    private func getReceipt(){
        firebasePurchase.getPayment { [unowned self]result  in
            switch result{
            case .failure(let error):
                break
                //todo
            case.success(let purchasedItems):
                guard let purchasedItems = purchasedItems else {delegate?.loadProduct();return}
                let items = purchasedItems.items
                    for item in items {
                        purchasedProductIdentifiers.insert(item.name)
                        delegate?.loadProduct()
                    }
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
            catch { print("Couldn't read receipt data with error: " + error.localizedDescription)
                savingError(id,productIdentifier)
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
                    savingError(id,productIdentifier)
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any]
                    if let receipt = json?["receipt"] as? [String: AnyObject],
                       let inApp = receipt["in_app"] as? [AnyObject] {
                        inApp.forEach({
                            if let transactionID = $0["transaction_id"] as? String,transactionID == id{
                                guard let dateString = $0["expires_date"] as? String,
                                      let purchaseKind = $0["product_id"] as? String else {delegate?.errorBeforeTransactionSave(id);return}
                                let item = PurchasedItem(name: purchaseKind, date: dateString, transactionID: transactionID)
                                firebasePurchase.setPayment(.init(items: [item])) { result in
                                    switch result{
                                    case .success:
                                        purchasedProductIdentifiers.insert(purchaseKind)
                                        delegate?.loadProduct()
                                    case .failure:
                                        savingError(id,productIdentifier)
                                    }
                                }
                            }else{
                                //if any error occured,app would save transcation id and try save purchase information again to db
                                delegate?.errorBeforeTransactionSave(id)
                                return
                            }
                        })
                    }else{
                        savingError(id,productIdentifier)
                        return
                    }
                }catch {
                    savingError(id,productIdentifier)
                    return
                }
            })
            task.resume()
        }else{
            savingError(id,productIdentifier)
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
        guard let user = service.getUserdNameAndId() else {fatalError()}
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
        print("Buying \(product.productIdentifier)...")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
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
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
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
                print("purchased before")
                complete(transaction: transaction)
                break
            case .failed:
                print("failed")
                fail(transaction: transaction)
                break
            case .restored:
                print("restored")
                restore(transaction: transaction)
                break
            case .deferred:
                print("deffered")
                break
            case .purchasing:
                print("purchasing")
                break
            default:
                break
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        let productIdentifier = transaction.payment.productIdentifier
        if let identifier = transaction.original?.transactionIdentifier {
            deliverPurchaseNotificationFor(identifier: productIdentifier)
            SKPaymentQueue.default().finishTransaction(transaction)
            setReceipt(identifier,productIdentifier)
            delegate?.purchaseCompleted()
        }else {
            guard let identifier = transaction.transactionIdentifier else { fatalError() }
            deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
            SKPaymentQueue.default().finishTransaction(transaction)
            setReceipt(identifier,productIdentifier)
            delegate?.purchaseCompleted()
        }
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        print("restore... \(productIdentifier)")
        deliverPurchaseNotificationFor(identifier: productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        if let transactionError = transaction.error as NSError?,
           let localizedDescription = transaction.error?.localizedDescription,
           transactionError.code != SKError.paymentCancelled.rawValue {
            print("Transaction Error: \(localizedDescription)")
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func deliverPurchaseNotificationFor(identifier: String?) {
        guard let identifier = identifier else { return }
        purchasedProductIdentifiers.insert(identifier)
        UserDefaults.standard.set(true, forKey: identifier)
        NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: identifier)
    }
    //MARK: - will delete
    private func checkReceipt(){
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
           FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
            var receiptString:String?
            do {
                let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                receiptString = receiptData.base64EncodedString(options: [])
            }
            catch { print("Couldn't read receipt data with error: " + error.localizedDescription)
      
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
                    delegate?.loadProduct()
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any]
                    if let receipt = json?["receipt"] as? [String: AnyObject],
                       let inApp = receipt["in_app"] as? [AnyObject] {
                        printNew("\(inApp)")
                        if (inApp.count > 0) {
                            //create purchased item array to prevent data usage for other times
                            var purchasedItems: PurchasedItems?
                            //control expire date of every product
                            var counter = 0
//                            for product in inApp{
//                                // check optinal data
//                                guard let dateString = product["expires_date"] as? String,
//                                      let purchaseKind = product["product_id"] as? String,
//                                      let transactionID = product["transaction_id"] as? String,
//                                      let expiresDate = Date.fromServerDateConverter(dateString: dateString)else{continue}
//                                //check date is valid or not
//                                let now = Date()
//                                //let fourDayBefore = Calendar.current.date(byAdding:.day , value: -10, to: now)
//
//                                if expiresDate.compare(now).rawValue>0{//date is valid
//                                    //add purchasedIdentifiers
//                                    purchasedProductIdentifiers.insert(purchaseKind)
//                                    //create purchasedItem and add it to purchased ITEMS
//                                    let purchasedItem = PurchasedItem(name: purchaseKind, date: dateString, transactionID: transactionID)
//                                    print(purchasedItem)
//                                    if purchasedItems == nil{
//                                        purchasedItems = PurchasedItems(items: [purchasedItem])
//                                    }else{
//                                        purchasedItems?.addNewItem(purchasedItem)
//                                    }
//                                    counter += 1
//                                }else{
//                                    counter += 1
//                                }
//                            }
//                            if counter == inApp.count && purchasedItems != nil{
//                            }
            
                        } else {
                
                            //empty array
                        }
                    }else{
              
                        // there is nothing to return
                    }
                }catch {
          
                }
            })
            task.resume()
        }else{
            //sandbox receipt would be empty array ,if there wasn't any purchase process before
        }
    }

    
}




