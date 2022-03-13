//
//  FirebasePaymentService.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 16.02.2022.
//

import Foundation
import FirebaseFunctions

enum PaymentError: Error{
    case resultError
    case optinalError
    case transactionError
    var localErrorDescription:String{
        switch self{
        case .resultError: return "Payment service error 1"
        case .optinalError: return  "Payment service error 2"
        case .transactionError: return "Transaction data save error. Please restart application"
        }
    }
}

final class FirebasePaymentService{
    let function = Functions.functions()
        
    static func setOldPayment(completion: @escaping (Results<String>)->Void){
        guard let savedData = UserDefaults.standard.data(forKey: "personWillSaveToDb"), let item = SavedPurchaseItem.dataToItem(data: savedData) else {completion(.success(nil)); return}
        let data = ["id":item.item.transactionID,"name":item.item.name,"purchaseDate":item.item.date,"userID":item.userID]
        let _function = Functions.functions()
        _function.httpsCallable("setOldPayment").call(data) { result, error in
            if let _ = error {
                completion(.failure(PaymentError.transactionError))
            }else{
                UserDefaults.standard.set(nil, forKey: "personWillSaveToDb")
                completion(.success(nil))
            }
        }
    }
    
    func setPayment(_ item:PurchasedItem,completion:@escaping(Results<String>)->Void){
        let data = ["id":item.transactionID,"name":item.name,"purchaseDate":item.date]
        function.httpsCallable("setPayment").call(data) { result, error in
            if let error = error {
                completion(.failure(PaymentError.transactionError))
            }else{
                completion(.success(nil))
            }
        }
    }
    func getPayment(completion:@escaping (Results<PurchasedItems>)->Void){
        function.httpsCallable("getPayment").call { result, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let data = result?.data as? NSDictionary,let array = data["array"] as? NSArray as? [Dictionary<String,String>] else {completion(.failure(PaymentError.resultError)); return}
            var purchaseItems:PurchasedItems?
            guard array != [] else{completion(.success(nil));return}
            array.forEach({
                guard let name = $0["name"],
                      let id = $0["id"],
                      let purchaseDate = $0["purchaseDate"] else {completion(.failure(PaymentError.optinalError)); return}
                let purchaseItem = PurchasedItem.init(name: name, date:purchaseDate  , transactionID:  id)
                purchaseItems == nil ? purchaseItems = PurchasedItems.init(items: [purchaseItem]) : purchaseItems?.addNewItem(purchaseItem)
                if purchaseItems?.items.count == array.count{
                    completion(.success(purchaseItems))
                }
            })
        }
    }
    
    func checkTransactionDidSavedBefore(_ transactionID:String, completion:@escaping (Results<TransactionCondition>)->Void) {
        let data = ["transactionID":transactionID]
        function.httpsCallable("checkTransactionDidSavedBefore").call(data) { response, error in
            if let error = error {
                completion(.failure(error))
            }else{
                guard let respondData = response?.data as? NSDictionary,
                      let result = respondData["result"] as? String else {completion(.failure(TransactionError.respondConvertError));return}
                let condition = TransactionCondition.init(rawValue: result)
                completion(.success(condition))
            }
        }
    }
    
}
