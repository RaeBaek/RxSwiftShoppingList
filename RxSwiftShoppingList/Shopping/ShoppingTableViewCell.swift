//
//  ShoppingTableViewCell.swift
//  RxSwiftShoppingList
//
//  Created by 백래훈 on 11/5/23.
//

import UIKit
import RxSwift
import RxCocoa

class ShoppingTableViewCell: UITableViewCell {
    
    let backView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 10
        return view
    }()
    
    let checkboxButton = {
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
    
    let bookmarkButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "star"), for: .normal)
        view.setImage(UIImage(systemName: "star.fill"), for: .selected)
        view.tintColor = .black
        return view
    }()
    
    var callBackMethod: (() -> (Void))?
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "Cell")
        confiureCell()
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
        
    }
    
    @objc func checkBoxClicked(sender: UIButton) {
        callBackMethod?()
    }
    
    @objc func bookmarkClicked(sender: UIButton) {
        callBackMethod?()
    }
    
    
    func confiureCell() {
        
        contentView.addSubview(backView)
        
        [checkboxButton, title, bookmarkButton].forEach {
            backView.addSubview($0)
        }
        
    }
    
    func setConstraints() {
        
        backView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(3)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        checkboxButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.size.equalTo(30)
        }
        
        title.snp.makeConstraints {
            $0.centerY.equalTo(checkboxButton.snp.centerY)
            $0.leading.equalTo(checkboxButton.snp.trailing).offset(16)
        }
        
        bookmarkButton.snp.makeConstraints {
            $0.centerY.equalTo(title.snp.centerY)
            $0.trailing.equalToSuperview().offset(-16)
            $0.size.equalTo(30)
        }
        
    }
    
}
