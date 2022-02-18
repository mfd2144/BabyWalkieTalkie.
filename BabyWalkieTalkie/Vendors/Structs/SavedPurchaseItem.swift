//
//  SavedPurchaseProduct.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 18.02.2022.
//

import Foundation

struct SavedPurchaseItem:Codable {
    let userID: String
    let item: PurchasedItem
}

extension SavedPurchaseItem {
    static func itemToData(item:SavedPurchaseItem)->Data? {
       let encoder = PropertyListEncoder()
        do {
            return try encoder.encode(item)
        } catch {
            return nil
        }
    }
    static func dataToItem(data:Data)->SavedPurchaseItem? {
        let decoder = PropertyListDecoder()
        do{
          return  try decoder.decode(SavedPurchaseItem.self, from: data)
        } catch {
            return nil
        }
    }
}
