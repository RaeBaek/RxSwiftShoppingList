//
//  ShoppingDetailViewController.swift
//  RxSwiftShoppingList
//
//  Created by 백래훈 on 11/6/23.
//

import UIKit
import RxSwift
import RxCocoa

protocol SendData {
    func sendEditData(row: Int, data: ShoppingModel)
}

class ShoppingDetailViewController: UIViewController {
    
    let editTextField = {
        let view = UITextField()
        view.textColor = .black
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 10
        return view
    }()
    
    let editButton = {
        let view = UIButton()
        view.setTitle("수정", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.backgroundColor = .systemGray6
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.cornerRadius = 10
        view.isEnabled = false
        return view
    }()
    
    let checkButton = {
        let view = UIButton()
        view.setTitle("확인", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.backgroundColor = .systemGray6
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    var delegate: SendData?
    
    let viewModel = ShoppingDetailViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(viewModel.word)
        print(viewModel.index)
        print(viewModel.data)
        
        bind()
        configureView()
        setConstraints()
        
    }
    
    func bind() {
        viewModel.item
            .bind(with: self) { owner, value in
                owner.editTextField.text = value?.title
                owner.navigationItem.title = value?.title
            }
            .disposed(by: disposeBag)
        
        viewModel.editButtonStatus
            .subscribe(with: self) { owner, value in
                owner.editButton.isEnabled = value
            }
            .disposed(by: disposeBag)
        
        editTextField.rx.text.orEmpty
            .subscribe(with: self) { owner, value in
                
                owner.viewModel.inputWord.onNext(value)
                owner.viewModel.data?.title = value
//                owner.viewModel.item.onNext(owner.data)
            }
            .disposed(by: disposeBag)
        
        editButton.rx.tap
            .subscribe(with: self) { owner, _ in
                if let data = owner.viewModel.data, let index = owner.viewModel.index {
                    owner.delegate?.sendEditData(row: index, data: data)
                    owner.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        checkButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    
    func configureView() {
        
        view.backgroundColor = .systemBackground
        
        [editTextField, editButton, checkButton].forEach {
            view.addSubview($0)
        }
    }
    
    func setConstraints() {
        
        editTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-20)
            $0.width.equalTo(300)
            $0.height.equalTo(70)
        }
        
        editButton.snp.makeConstraints {
            $0.centerX.equalTo(editTextField.snp.centerX)
            $0.top.equalTo(editTextField.snp.bottom).offset(16)
            $0.size.equalTo(70)
        }
        
        checkButton.snp.makeConstraints {
            $0.centerX.equalTo(editButton.snp.centerX)
            $0.top.equalTo(editButton.snp.bottom).offset(16)
            $0.size.equalTo(70)
        }
        
    }
    
}
