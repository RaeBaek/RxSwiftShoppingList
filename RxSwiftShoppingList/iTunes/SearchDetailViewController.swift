//
//  SearchDetailViewController.swift
//  RxSwiftShoppingList
//
//  Created by 백래훈 on 11/10/23.
//

import UIKit
import RxSwift
import RxCocoa

class SearchDetailViewController: UIViewController {
    
    let appIconImage = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 20
        view.layer.cornerCurve = .continuous
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray6.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    let appNameLabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .systemFont(ofSize: 18, weight: .medium)
        view.numberOfLines = 0
        return view
    }()
    
    let developerLabel = {
        let view = UILabel()
        view.textColor = .darkGray
        view.font = .systemFont(ofSize: 13, weight: .regular)
        return view
    }()
    
    let receiveButton = {
        let view = UIButton()
        
        var buttonConfig = UIButton.Configuration.filled() //apple system button
        buttonConfig.baseForegroundColor = .white
        buttonConfig.baseBackgroundColor = .systemBlue
        buttonConfig.cornerStyle = .capsule
        
        var titleAttr = AttributedString.init("받기")
            titleAttr.font = .systemFont(ofSize: 15.0, weight: .bold)
        buttonConfig.attributedTitle = titleAttr
        
        view.configuration = buttonConfig
        return view
    }()
    
    let shareButton = {
        let view = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: "square.and.arrow.up", withConfiguration: imageConfig)
        view.tintColor = .systemBlue
        view.setImage(image, for: .normal)
        view.imageView?.contentMode = .scaleAspectFit
        return view
    }()
    
    let newTopic = {
        let view = UILabel()
        view.text = "새로운 소식"
        view.textColor = .black
        view.font = .systemFont(ofSize: 18, weight: .medium)
        return view
    }()
    
    let versionLabel = {
        let view = UILabel()
        view.textColor = .darkGray
        view.font = .systemFont(ofSize: 13, weight: .regular)
        return view
    }()
    
    let releaseNoteLabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .systemFont(ofSize: 13, weight: .regular)
        return view
    }()
    
    let descriptionLabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .systemFont(ofSize: 13, weight: .regular)
        view.numberOfLines = 0
        return view
    }()
    
    let previewLabel = {
        let view = UILabel()
        view.text = "미리보기"
        view.textColor = .black
        return view
    }()
    
    lazy var previewCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: setCollectionViewLayout())
        view.register(PreviewCollectionViewCell.self, forCellWithReuseIdentifier: PreviewCollectionViewCell.identifier)
        return view
    }()
    
    // 단순 보여지는 화면인데 MVVM 패턴이 맞을지!!!!!!!!!!!!!!!
    var appInfo: AppInfo?
    
    let viewModel = SearchDetailViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appInfo else { return }
        viewModel.appInfo = appInfo
        
        setNavigationBar()
        configureView()
        setConstraints()
        bind()
        setNavigationBar()
        
    }
    
    func bind() {
        viewModel.selectApp
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, value in
                owner.appIconImage.kf.setImage(with: URL(string: value.artworkUrl512))
                owner.appNameLabel.text = value.trackName
                owner.developerLabel.text = value.sellerName
                owner.versionLabel.text = "버전 \(value.version)"
                owner.releaseNoteLabel.text = value.releaseNotes
                owner.descriptionLabel.text = value.description
                
            }
            .disposed(by: disposeBag)
        
        viewModel.screenShots
            .observe(on: MainScheduler.instance)
            .bind(to: previewCollectionView.rx.items(cellIdentifier: PreviewCollectionViewCell.identifier, cellType: PreviewCollectionViewCell.self)) { (row, element, cell) in
                let firstScreenShot = URL(string: element)
                
                cell.imageView.kf.setImage(with: firstScreenShot)
            }
            .disposed(by: disposeBag)
        
    }
    
    func setNavigationBar() {
        
        view.backgroundColor = .systemBackground
        
        viewModel.selectApp
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, value in
                owner.title = value.trackName
            }
            .disposed(by: disposeBag)
        
        viewModel.largeTitleStatus
            .withUnretained(self)
            .bind { owner, value in
                owner.navigationController?.navigationBar.prefersLargeTitles = value
            }
            .disposed(by: disposeBag)
        
    }
    
    func setCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 10
        
        return layout
    }
    
    func configureView() {
        view.backgroundColor = .systemBackground
        
        [appIconImage, appNameLabel, developerLabel, receiveButton, shareButton, newTopic, versionLabel, releaseNoteLabel, descriptionLabel].forEach {
            view.addSubview($0)
        }
        
    }
    
    func setConstraints() {
        appIconImage.snp.makeConstraints {
            $0.top.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.size.equalTo(110)
        }
        
        appNameLabel.snp.makeConstraints {
            $0.top.equalTo(appIconImage.snp.top)
            $0.leading.equalTo(appIconImage.snp.trailing).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
        
        developerLabel.snp.makeConstraints {
            $0.top.equalTo(appNameLabel.snp.bottom).offset(5)
            $0.leading.equalTo(appIconImage.snp.trailing).offset(16)
        }
        
        receiveButton.snp.makeConstraints {
            $0.leading.equalTo(appIconImage.snp.trailing).offset(16)
            $0.bottom.equalTo(appIconImage.snp.bottom)
            $0.width.equalTo(70)
            $0.height.equalTo(30)
        }
        
        shareButton.snp.makeConstraints {
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.centerY.equalTo(receiveButton.snp.centerY)
            $0.size.equalTo(25)
        }
        
        newTopic.snp.makeConstraints {
            $0.top.equalTo(appIconImage.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        versionLabel.snp.makeConstraints {
            $0.top.equalTo(newTopic.snp.bottom).offset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        releaseNoteLabel.snp.makeConstraints {
            $0.top.equalTo(versionLabel.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(releaseNoteLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
    }
    
}
