//
//  SearchViewModel.swift
//  RxSwiftShoppingList
//
//  Created by 백래훈 on 11/7/23.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {
    
    struct Input {
        let searchButtonClicked: ControlEvent<Void>
        let cancelButtonClicked: ControlEvent<Void>
        let searchText: ControlProperty<String>
        let cellSelected: ControlEvent<AppInfo>
        
    }
    
    struct Output {
        let result: PublishRelay<[AppInfo]>
        let selectApp: PublishRelay<AppInfo>
    }
    
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let result = PublishRelay<[AppInfo]>()
        let selectApp = PublishRelay<AppInfo>()
        
        input.searchText
            .distinctUntilChanged()
//            .map { _ in
//                return result
//            }
//            .flatMap { $0 }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, _ in
                result.accept([])
            }
            .disposed(by: disposeBag)
        
        input.searchButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText, resultSelector: { _, text in
                print(text)
                return text
            })
            .map { String($0) }
            .flatMap { //value in
                ItunesAPIManager.fetchData(query: $0)
            }
            .withUnretained(self)
            .bind { owner, app in
                let data = app.results
                result.accept(data)
            }
            .disposed(by: disposeBag)
        
        input.cancelButtonClicked
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, _ in
                result.accept([])
            }
            .disposed(by: disposeBag)
        
        input.cellSelected
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, value in
                selectApp.accept(value)
            }
            .disposed(by: disposeBag)
        
        return Output(result: result, selectApp: selectApp)
    }
    
}
