//
//  Extension + UICollectionViewCell.swift
//  RxSwiftShoppingList
//
//  Created by 백래훈 on 11/11/23.
//

import UIKit

extension UICollectionViewCell: ReusableProtocol {
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
