//
//  Results.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 8.08.2021.
//

import Foundation

public enum Results<Value>{
    case success(Value?)
    case failure(Error)
}


public enum FirebaseResults<T>{
    case failure(FirebaseError)
    case success(T)
}
