//
//  ShoppingDetailViewModel.swift
//  RxSwiftShoppingList
//
//  Created by 백래훈 on 11/6/23.
//

import Foundation
import RxSwift
import RxCocoa

class ShoppingDetailViewModel {
    
    var word: String?
    
    var index: Int?
    var data: ShoppingModel?
    
    lazy var item = BehaviorSubject(value: data)
    
    lazy var inputWord = BehaviorSubject(value: word)
    let outputWord = PublishSubject<String>()
    
    let editButtonStatus = BehaviorSubject(value: false)
    
    let disposeBag = DisposeBag()
    
    init() {
        
        inputWord
            .map { $0 == self.word }
            .subscribe(with: self) { owner, value in
                print(value)
                owner.editButtonStatus.onNext(!value)
            }
            .disposed(by: disposeBag)
        
        inputWord
            .subscribe(with: self) { owner, value in
                guard let value else { return }
                owner.outputWord.onNext(value)
            }
            .disposed(by: disposeBag)
    }
    
    
}
