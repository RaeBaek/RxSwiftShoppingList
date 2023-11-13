//
//  SearchDetailViewController.swift
//  RxSwiftShoppingList
//
//  Created by 백래훈 on 11/10/23.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class SearchDetailViewController: UIViewController {
    
    private lazy var scrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = true
        view.isScrollEnabled = true
        view.bounces = true
        view.delegate = self
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let contentView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let appIconImage = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 20
        view.layer.cornerCurve = .continuous
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray6.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    private let appNameLabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .systemFont(ofSize: 18, weight: .medium)
        view.numberOfLines = 0
        return view
    }()
    
    private let developerLabel = {
        let view = UILabel()
        view.textColor = .darkGray
        view.font = .systemFont(ofSize: 13, weight: .regular)
        return view
    }()
    
    private let receiveButton = {
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
    
    private let shareButton = {
        let view = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: "square.and.arrow.up", withConfiguration: imageConfig)
        view.tintColor = .systemBlue
        view.setImage(image, for: .normal)
        view.imageView?.contentMode = .scaleAspectFit
        return view
    }()
    
    private let newTopic = {
        let view = UILabel()
        view.text = "새로운 소식"
        view.textColor = .black
        view.font = .systemFont(ofSize: 18, weight: .semibold)
        return view
    }()
    
    private let versionLabel = {
        let view = UILabel()
        view.textColor = .darkGray
        view.font = .systemFont(ofSize: 13, weight: .regular)
        return view
    }()
    
    private let releaseNoteLabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .systemFont(ofSize: 13, weight: .regular)
        return view
    }()
    
    private let previewLabel = {
        let view = UILabel()
        view.text = "미리보기"
        view.textColor = .black
        view.font = .systemFont(ofSize: 18, weight: .semibold)
        return view
    }()
    
    private lazy var previewCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: setCollectionViewLayout())
        view.register(PreviewCollectionViewCell.self, forCellWithReuseIdentifier: PreviewCollectionViewCell.identifier)
        view.delegate = self
//        view.dataSource = self
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private let descriptionLabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .systemFont(ofSize: 13, weight: .regular)
        view.numberOfLines = 0
        return view
    }()
    
    var appInfo: AppInfo?
    
    private let viewModel = SearchDetailViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        setConstraints()
        bind()
        setNavigationBar()
        
    }
    
    func bind() {
        guard let appInfo else { return }
        
        let input = SearchDetailViewModel.Input(appInfo: appInfo)
        
        let output = viewModel.transform(input: input)
        
        output.selectApp
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
        
        output.selectApp
            .flatMap { value in
                let data = BehaviorRelay(value: value.screenshotUrls)
                return data
            }
            .map { $0 }
            .bind(to: previewCollectionView.rx.items(cellIdentifier: PreviewCollectionViewCell.identifier, cellType: PreviewCollectionViewCell.self)) { (row, element, cell) in
                
                cell.imageView.kf.setImage(with: URL(string: element))
                
            }
            .disposed(by: disposeBag)
        
        output.largeTitleStatus
            .bind(with: self) { owner, bool in
                owner.navigationController?.navigationBar.prefersLargeTitles = bool
            }
            .disposed(by: disposeBag)
        
    }
    
    func setNavigationBar() {
        view.backgroundColor = .systemBackground
        
    }
    
    func setCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let spacing: CGFloat = 16
        
        layout.scrollDirection = .horizontal
        
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        
        return layout
    }
    
    func configureView() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        [appIconImage, appNameLabel, developerLabel, receiveButton, shareButton, newTopic, versionLabel, releaseNoteLabel, descriptionLabel, previewLabel, previewCollectionView].forEach {
            contentView.addSubview($0)
        }
        
    }
    
    func setConstraints() {
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        appIconImage.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
            $0.size.equalTo(110)
        }
        
        appNameLabel.snp.makeConstraints {
            $0.top.equalTo(appIconImage.snp.top)
            $0.leading.equalTo(appIconImage.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().offset(-16)
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
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalTo(receiveButton.snp.centerY)
            $0.size.equalTo(25)
        }
        
        newTopic.snp.makeConstraints {
            $0.top.equalTo(appIconImage.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        versionLabel.snp.makeConstraints {
            $0.top.equalTo(newTopic.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
        }
        
        releaseNoteLabel.snp.makeConstraints {
            $0.top.equalTo(versionLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        previewLabel.snp.makeConstraints {
            $0.top.equalTo(releaseNoteLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        previewCollectionView.snp.makeConstraints {
            $0.top.equalTo(previewLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(contentView.snp.width).multipliedBy(1.2)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(previewCollectionView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
    }
    
}

extension SearchDetailViewController: UIScrollViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width * 0.6
        
        return CGSize(width: width, height: width * 2)
        
    }
}
