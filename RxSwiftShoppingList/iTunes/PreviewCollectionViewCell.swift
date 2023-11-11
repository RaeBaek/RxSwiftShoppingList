//
//  PreviewCollectionViewCell.swift
//  RxSwiftShoppingList
//
//  Created by 백래훈 on 11/11/23.
//

import UIKit

class PreviewCollectionViewCell: UICollectionViewCell {
    
    let imageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 20
        view.layer.cornerCurve = .continuous
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray4.cgColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        contentView.addSubview(imageView)
    }
    
    func setConstraint() {
        imageView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.width.equalTo(imageView.snp.height).multipliedBy(0.5)
        }
    }
    
}
