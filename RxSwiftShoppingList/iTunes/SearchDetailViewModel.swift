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
    
    struct Input {
        var appInfo: AppInfo
    }
    
    struct Output {
        let selectApp: BehaviorRelay<AppInfo>
        let largeTitleStatus: Observable<Bool>
    }
    
    init() {
        print("SearchDetailViewModel Init!")
    }
    
    deinit {
        print("SearchDetailViewModel Deinit!")
    }
    
    func transform(input: Input) -> Output {
        
        let selectApp = BehaviorRelay(value: input.appInfo)
        let largeTitleStatus = Observable.of(false)
        
        return Output(selectApp: selectApp, largeTitleStatus: largeTitleStatus)
    }
    
    
}
