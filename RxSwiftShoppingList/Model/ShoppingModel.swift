//
//  ShoppingModel.swift
//  RxSwiftShoppingList
//
//  Created by 백래훈 on 11/5/23.
//

import Foundation

struct ShoppingModel {
    var check: Bool
    var title: String
    var bookmark: Bool
}

struct ShoppingList {
    var list = [
        ShoppingModel(check: false, title: "그립톡 구매하기", bookmark: false),
        ShoppingModel(check: false, title: "양말", bookmark: false),
        ShoppingModel(check: false, title: "아이패드 케이스 최저가 알아보기", bookmark: false),
        ShoppingModel(check: false, title: "사이다 구매", bookmark: false)
    ]
    
}
