//
//  Date.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 21.12.2021.
//

import Foundation


extension Date{
   static func actualStringTime()->String{
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "HH:mm"
        let nowString = dateFormatter.string(from: now)
        return nowString
    }
    
    static func fromServerDateConverter(dateString: String) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let dateObject = dateFormatter.date(from: dateString)
        return dateObject
    }

}
