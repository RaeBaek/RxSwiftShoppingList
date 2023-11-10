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

class ShoppingViewController: UIViewController, SendData {
    
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
        view.isEnabled = false
//        view.setContentHuggingPriority(.init(rawValue: 251), for: .horizontal)
        return view
    }()
    
    lazy var shoppingTableView = {
        let view = UITableView()
        view.rowHeight = 60
        view.register(ShoppingTableViewCell.self, forCellReuseIdentifier: "Cell")
        return view
    }()
    
    let viewModel = ShoppingViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "쇼핑"
        configureView()
        setConstraints()
    
        bind()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(viewModel.items)
        
    }
    
    func bind() {
        viewModel.outputItems
            .bind(to: shoppingTableView.rx.items(cellIdentifier: "Cell", cellType: ShoppingTableViewCell.self)) {
                (row, element, cell) in
                
                cell.selectionStyle = .none
                
                cell.checkboxButton.isSelected = element.check
                cell.title.text = element.title
                cell.bookmarkButton.isSelected = element.bookmark
                
                cell.checkboxButton.rx.tap
                    .subscribe(with: self) { owner, _ in
                        print("===?", row)
                        owner.viewModel.checkboxClicked(index: row, value: !element.check)
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.bookmarkButton.rx.tap
                    .subscribe(with: self) { owner, _ in
                        print("===!", row, !element.bookmark)
                        owner.viewModel.bookmarkClicked(index: row, value: !element.bookmark)
                    }
                    .disposed(by: cell.disposeBag)
                
            }
            .disposed(by: disposeBag)
        
        viewModel.buttonStatus
            .bind(to: addButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.word
            .bind(to: shoppingTextField.rx.text)
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .subscribe(with: self) { owner, _ in
                guard let title = owner.shoppingTextField.text else { return }
                let data = ShoppingModel(check: false, title: title, bookmark: false)
                
                owner.viewModel.createItem(item: data)
                owner.shoppingTextField.text = ""
            }
            .disposed(by: disposeBag)
        
        shoppingTextField.rx.text.orEmpty
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                owner.viewModel.word.onNext(value)
                
                let result = value == "" ? owner.viewModel.items.list : owner.viewModel.items.list.filter { $0.title.contains(value) }
                
//                owner.viewModel.items.list = result
                owner.viewModel.inputItems.onNext(result)
            }
            .disposed(by: disposeBag)
        
        shoppingTableView.rx.itemSelected
            .subscribe(with: self) { owner, indexPath in
                let vc = ShoppingDetailViewController()
                
                vc.viewModel.index = indexPath.row
                vc.viewModel.data = owner.viewModel.items.list[indexPath.row]
                vc.viewModel.word = owner.viewModel.items.list[indexPath.row].title
                vc.delegate = self
                
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        shoppingTableView.rx.modelSelected(ShoppingModel.self)
            .subscribe(with: self) { owner, element in
                print(element)
            }
            .disposed(by: disposeBag)
        
        shoppingTableView.rx.itemDeleted
            .bind(with: self) { owner, indexPath in
                owner.viewModel.deleteItem(index: indexPath.row)
                owner.shoppingTextField.text = ""
            }
            .disposed(by: disposeBag)
        
    }
    
    func sendEditData(row: Int, data: ShoppingModel) {
        self.viewModel.items.list[row] = data
        self.viewModel.outputItems.onNext(self.viewModel.items.list)
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

//extension ShoppingViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ShoppingTableViewCell else { return UITableViewCell() }
//        
//        cell.checkboxButton.isSelected = data[indexPath.row].bookmark
//        cell.title.text = data[indexPath.row].title
//        cell.bookmarkButton.isSelected = data[indexPath.row].bookmark
//        
//        cell.checkboxButton.tag = indexPath.row
//        cell.bookmarkButton.tag = indexPath.row
//        
//        cell.checkboxButton.addTarget(self, action: #selector(checkBoxClicked(sender:)), for: .touchUpInside)
//        cell.bookmarkButton.addTarget(self, action: #selector(bookmarkClicked(sender:)), for: .touchUpInside)
//        
//        return cell
//    }
//    
//    
//}
