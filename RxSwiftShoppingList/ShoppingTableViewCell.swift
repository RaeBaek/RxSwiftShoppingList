//
//  ShoppingTableViewCell.swift
//  RxSwiftShoppingList
//
//  Created by 백래훈 on 11/5/23.
//

import UIKit

class ShoppingTableViewCell: UITableViewCell {
    
    let backView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 10
        return view
    }()
    
    let checkBox = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        view.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        view.tintColor = .black
        return view
    }()
    
    let title = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 17, weight: .regular)
        view.textColor = .black
        return view
    }()
    
    let bookmark = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "star"), for: .normal)
        view.setImage(UIImage(systemName: "star.fill"), for: .selected)
        view.tintColor = .black
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "Cell")
        confiureCell()
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func confiureCell() {
        
        contentView.addSubview(backView)
        
        [checkBox, title, bookmark].forEach {
            backView.addSubview($0)
        }
        
    }
    
    func setConstraints() {
        
        backView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(3)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        checkBox.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.size.equalTo(30)
        }
        
        title.snp.makeConstraints {
            $0.centerY.equalTo(checkBox.snp.centerY)
            $0.leading.equalTo(checkBox.snp.trailing).offset(16)
        }
        
        bookmark.snp.makeConstraints {
            $0.centerY.equalTo(title.snp.centerY)
            $0.trailing.equalToSuperview().offset(-16)
            $0.size.equalTo(30)
        }
        
    }
    
}
