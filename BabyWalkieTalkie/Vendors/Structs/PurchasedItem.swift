//
//  PurchasedItem.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 12.02.2022.
//

import Foundation

struct PurchasedItem:Codable{
    let name:String
    let date:String
    let transactionID:String
}
struct PurchasedItems:Codable{
    var items:[PurchasedItem]
    
    mutating func addNewItem(_ item: PurchasedItem){

        self.items.append(item)
    }
}

extension PurchasedItems{
    mutating func deletePurchasedItem(id:String){
        var index = 0
        for i in items{
            if i.transactionID == id{
                items.remove(at: index)
                return
            }else{
                index += 1
            }
        }
    }
}


