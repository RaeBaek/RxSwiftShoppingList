//
//  ShoppingViewController.swift
//  RxSwiftShoppingList
//
//  Created by 백래훈 on 11/3/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ShoppingViewController: UIViewController {
    
    let backView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 10
        return view
    }()
    
    let shoppingTextField = {
        let view = UITextField()
        view.backgroundColor = .clear
        view.placeholder = "무엇을 구매하실 건가요?"
        view.setContentHuggingPriority(.init(rawValue: 250), for: .horizontal)
        return view
    }()
    
    let addButton = {
        let view = UIButton()
        view.backgroundColor = .systemGray5
        view.setTitleColor(.black, for: .normal)
        view.setTitle("추가", for: .normal)
        view.layer.cornerRadius = 10
//        view.setContentHuggingPriority(.init(rawValue: 251), for: .horizontal)
        return view
    }()
    
    lazy var shoppingTableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.rowHeight = 60
        view.register(ShoppingTableViewCell.self, forCellReuseIdentifier: "Cell")
        return view
    }()
    
    var data = ShoppingList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "쇼핑"
        configureView()
        setConstraints()
        
        data.append(ShoppingModel(check: false, title: "양말", bookmark: false))
        data.append(ShoppingModel(check: false, title: "아이패드 케이스 최저가 알아보기", bookmark: false))
        data.append(ShoppingModel(check: false, title: "사이다 구매", bookmark: false))
        data.append(ShoppingModel(check: false, title: "그립톡 구매하기", bookmark: false))
        
    }
    
    @objc func checkBoxClicked(sender: UIButton) {
        print("\(sender.tag) 체크박스 버튼의 Tag로 index값을 받아서 데이터 처리")
    }
    
    @objc func bookmarkClicked(sender: UIButton) {
        print("\(sender.tag) 북마크 버튼의 Tag로 index값을 받아서 데이터 처리")
    }
    
    func configureView() {
        
        view.backgroundColor = .systemBackground
        
        [backView, shoppingTableView].forEach {
            view.addSubview($0)
        }
        
        [shoppingTextField, addButton].forEach {
            backView.addSubview($0)
        }
        
    }
    
    func setConstraints() {
        
        backView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(70)
        }
        
        shoppingTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalTo(addButton.snp.leading).offset(-16)
        }
        
        addButton.snp.makeConstraints {
            $0.centerY.equalTo(shoppingTextField.snp.centerY)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(60)
            $0.height.equalTo(40)
        }
        
        shoppingTableView.snp.makeConstraints {
            $0.top.equalTo(backView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            
        }
        
    }
    
}

extension ShoppingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ShoppingTableViewCell else { return UITableViewCell() }
        
        cell.checkBox.isSelected = data[indexPath.row].bookmark
        cell.title.text = data[indexPath.row].title
        cell.bookmark.isSelected = data[indexPath.row].bookmark
        
        cell.checkBox.tag = indexPath.row
        cell.bookmark.tag = indexPath.row
        
        cell.checkBox.addTarget(self, action: #selector(checkBoxClicked(sender:)), for: .touchUpInside)
        cell.bookmark.addTarget(self, action: #selector(bookmarkClicked(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    
}
