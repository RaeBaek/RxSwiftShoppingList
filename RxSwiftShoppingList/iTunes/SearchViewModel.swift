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
        // searchController.searchBar.rx.searchButtonClicked
        let searchText: ControlProperty<String>
        // searchController.searchBar.rx.text.orEmpty
        
    }
    
    struct Output {
        let result: PublishRelay<[AppInfo]>
    }
    
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let word = PublishRelay<String>()
        let result = PublishRelay<[AppInfo]>()
        
        word
            .bind(to: input.searchText)
            .disposed(by: disposeBag)
        
        input.searchButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText, resultSelector: { _, text in
                return text
            })
            .map { String($0) }
            .flatMap { //value in
                ItunesAPIManager.fetchData(query: $0)
            }
            .subscribe(with: self) { owner, app in
                let data = app.results
                result.accept(data)
            }
            .disposed(by: disposeBag)
        
        return Output(result: result)
    }
    
    
}
