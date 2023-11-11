//
//  SearchDetailViewModel.swift
//  RxSwiftShoppingList
//
//  Created by 백래훈 on 11/10/23.
//

import Foundation
import RxSwift
import RxCocoa

class SearchDetailViewModel {
    
    // 단순 보여지는 화면인데 MVVM 패턴이 맞을지!!!!!!!!!!!!!!
    // AppInfo 안에 각각의 값들이 있는데 미리보기 스크린샷은 값을 어떻게 뺄 것인지!!!!!!!!!!!
    var appInfo: AppInfo?
    
    let largeTitleStatus = Observable.of(false)
    lazy var selectApp = PublishRelay<AppInfo>()
    lazy var screenShots = PublishRelay<[String]>()
    
    init() {
        guard let appInfo else { return }
        
        selectApp.accept(appInfo)
        screenShots.accept(appInfo.screenshotUrls)
    }
    
    
}
