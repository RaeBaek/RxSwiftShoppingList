//
//  ShoppingViewModel.swift
//  RxSwiftShoppingList
//
//  Created by 백래훈 on 11/3/23.
//

import Foundation
import RxSwift
import RxCocoa

class ShoppingViewModel {
    
    let word = PublishSubject<String>()
    let buttonStatus = BehaviorSubject(value: false)
    
    var items = ShoppingList()
    lazy var inputItems = BehaviorSubject(value: items.list)
    let outputItems = PublishSubject<[ShoppingModel]>()
    let disposeBag = DisposeBag()
    
    init() {
        
        word
            .map { $0.count >= 2 }
            .subscribe(with: self) { owner, value in
                owner.buttonStatus.onNext(value)
            }
            .disposed(by: disposeBag)
        
        inputItems
            .subscribe(with: self) { owner, items in
                owner.outputItems.onNext(items)
            }
            .disposed(by: disposeBag)
        
    }
    
    func createItem(item: ShoppingModel) {
        self.items.list.insert(item, at: 0)
        self.inputItems.onNext(self.items.list)
    }
    
    func deleteItem(index: Int) {
        self.items.list.remove(at: index)
        self.inputItems.onNext(self.items.list)
    }
    
    func checkboxClicked(index: Int, value: Bool) {
        self.items.list[index].check = value
        self.inputItems.onNext(self.items.list)
    }
    
    func bookmarkClicked(index: Int, value: Bool) {
        self.items.list[index].bookmark = value
        self.inputItems.onNext(self.items.list)
    }
    
    
}
