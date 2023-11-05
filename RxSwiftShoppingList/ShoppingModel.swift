//
//  ShoppingModel.swift
//  RxSwiftShoppingList
//
//  Created by 백래훈 on 11/5/23.
//

import Foundation

struct ShoppingModel {
    let check: Bool
    let title: String
    let bookmark: Bool
}

typealias ShoppingList = [ShoppingModel]
