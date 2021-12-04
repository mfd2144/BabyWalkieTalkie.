//
//  IAPTableBuilder.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 21.11.2021.
//

import UIKit

final class IAPTableBuilder{
    static func make(iAPHelper:IAPHelper)->UIViewController{
        let view = IAPTableView()
        view.helper = iAPHelper
        view.modalTransitionStyle = .crossDissolve
        view.modalPresentationStyle = .overCurrentContext
        return view
    }
}
