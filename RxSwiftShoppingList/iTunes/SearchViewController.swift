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
    
    let viewModel = SearchViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        configureView()
        setConstraints()
        
        bind()
        
    }
    
    func bind() {
        let input = SearchViewModel.Input(
            searchButtonClicked: searchController.searchBar.rx.searchButtonClicked,
            cancelButtonClicked: searchController.searchBar.rx.cancelButtonClicked,
            searchText: searchController.searchBar.searchTextField.rx.text.orEmpty,
            cellSelected: searchTableView.rx.modelSelected(AppInfo.self)
        )
        
        let output = viewModel.transform(input: input)
        
        output.result
            .observe(on: MainScheduler.instance)
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
        
        output.selectApp
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, app in
                owner.pushViewControllerBySelectApp(selectApp: app)
            }
            .disposed(by: disposeBag)
        
    }
    
    func pushViewControllerBySelectApp(selectApp: AppInfo) {
        let vc = SearchDetailViewController()
        vc.selectApp = selectApp
        
        navigationController?.pushViewController(vc, animated: true)
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
