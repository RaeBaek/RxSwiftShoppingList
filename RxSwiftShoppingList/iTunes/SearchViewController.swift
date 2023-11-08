//
//  SearchViewController.swift
//  RxSwiftShoppingList
//
//  Created by 백래훈 on 11/7/23.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class SearchViewController: UIViewController {
    
    let searchController = {
        let view = UISearchController()
        return view
    }()
    
    let searchTableView = {
        let view = UITableView()
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: "SearchCell")
        return view
    }()
    
    var text: String = ""
    
    let word = PublishRelay<String>()
    
    let result = PublishRelay<[AppInfo]>()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        configureView()
        setConstraints()
        
        bind()
        
    }
    
    func bind() {
        word
            .bind(to: searchController.searchBar.rx.text.orEmpty)
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.searchButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(searchController.searchBar.rx.text.orEmpty, resultSelector: { _, text in
                return text
            })
            .map { String($0) }
            .flatMap { //value in
                ItunesAPIManager.fetchData(query: $0)
            }
            .subscribe(with: self) { owner, app in
                let data = app.results
                owner.result.accept(data)
            }
            .disposed(by: disposeBag)
//            .flatMap { ItunesAPIManager.fetchData(query: $0) }
//            .subscribe(with: self) { owner, app in
//                print(app)
//                let data = app.results
//                owner.result.accept(app)
//            }
//            .disposed(by: disposeBag)
//            .flatMap { text in
//                ItunesAPIManager.fetchData(query: text)
//            }
//            .subscribe(with: self) { owner, app in
//                print(app)
//                let data = app.results
//                owner.result.accept(app)
//            }
//            .disposed(by: disposeBag)
        
//            .subscribe(with: self) { owner, value in
//                print(value)
//                owner.word.accept(value)
//            }
//            .disposed(by: disposeBag)
        
//        let datas = ItunesAPIManager.fetchData(query: word)
        
//        print("===", datas)
//        
//        datas
//            .subscribe(with: self) { owner, value in
//                owner.result.accept(value.results)
//            }
//            .disposed(by: disposeBag)
        
        result
            .bind(to: searchTableView.rx.items(cellIdentifier: "SearchCell", cellType: SearchTableViewCell.self)) { (row, element, cell) in
                
                let iconImageUrl = URL(string: element.artworkUrl512)
                let startPoint = round(element.averageUserRating * 10000 / 10000)
                let firstScreenShotImage = URL(string: element.screenshotUrls[0])
                let secondScreenShotImage = URL(string: element.screenshotUrls[1])
                let thirdScreenShotImage = URL(string: element.screenshotUrls[2])
                
                cell.appIconImage.kf.setImage(with: iconImageUrl)
                cell.appNameLabel.text = element.trackName
                cell.starPoint.text = "\(startPoint)점"
                cell.developerLabel.text = element.sellerName
                cell.genreLabel.text = element.genres.first
                
                cell.firstScreenShotImage.kf.setImage(with: firstScreenShotImage)
                cell.secondScreenShotImage.kf.setImage(with: secondScreenShotImage)
                cell.thirdScreenShotImage.kf.setImage(with: thirdScreenShotImage)
                
                cell.selectionStyle = .none
                
            }
            .disposed(by: disposeBag)
        
    }
    
    func configureView() {
        view.backgroundColor = .systemBackground
        
        [searchTableView].forEach {
            view.addSubview($0)
        }
        
    }
    
    func setConstraints() {
        searchTableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    func setNavigationBar() {
        title = "검색"
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "게임, 앱, 스토리 등"
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
}
