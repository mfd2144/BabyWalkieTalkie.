//
//  FirebasePaymentService.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 16.02.2022.
//

import Foundation
import FirebaseFunctions

final class FirebasePaymentService{
    let function = Functions.functions()
    enum PaymentError:String, Error{
        case resultError
        case optinalError
    }
    
    static func setOldPayment(){
        guard let item = UserDefaults.standard.object(forKey: "personWillSaveToDb") as? SavedPurchaseItem else {return}
        let data = ["id":item.item.transactionID,"name":item.item.name,"expiresDate":item.item.date,"userID":item.userID]
        let _function = Functions.functions()
        _function.httpsCallable("setOldPayment").call(data) { result, error in
            UserDefaults.standard.set(nil, forKey: "personWillSaveToDb")
        }
    }
    
    func setPayment(_ items:PurchasedItems,completion:(Results<String>)->Void){
        var data = [[String:String]]()
        for item in items.items{
            let array = ["id":item.transactionID,"name":item.name,"expiresDate":item.date]
            data.append(array)
        }
        function.httpsCallable("setPayment").call(data) { result, error in
            
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
                      let expiresDate = $0["expiresDate"] else {completion(.failure(PaymentError.optinalError)); return}
                 let purchaseItem = PurchasedItem.init(name: name, date:expiresDate  , transactionID:  id)
                purchaseItems == nil ? purchaseItems = PurchasedItems.init(items: [purchaseItem]) : purchaseItems?.addNewItem(purchaseItem)
                if purchaseItems?.items.count == array.count{
                    completion(.success(purchaseItems))
                }
            })
        }
    }
}
