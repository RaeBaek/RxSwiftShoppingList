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

struct SearchAppModel: Codable {
    let resultCount: Int
    let results: [AppInfo]
}

struct AppInfo: Codable {
    let screenshotUrls: [String]
    let trackName: String // 이름
    let genres: [String] // 장르
    let trackContentRating: String // 연령제한
    let description: String // 설명
    let price: Double // 가격
    let sellerName: String // 개발자 이름
    let formattedPrice: String // 가격(무료/유료)
    let userRatingCount: Int // 평가자 수
    let averageUserRating: Double // 평균 평점
    let artworkUrl512: String // 아이콘 이미지
    let languageCodesISO2A: [String] // 언어 지원
    let trackId: Int
    let version: String
    let releaseNotes: String
    
}

