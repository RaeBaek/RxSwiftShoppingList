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
    
    var selectApp: AppInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        configureView()
        setConstraints()
        bind()
        
    }
    
    func bind() {
        guard let selectApp else { return }
        
        appIconImage.kf.setImage(with: URL(string: selectApp.artworkUrl512))
        appNameLabel.text = selectApp.trackName
        developerLabel.text = selectApp.sellerName
        versionLabel.text = "버전 \(selectApp.version)"
        releaseNoteLabel.text = selectApp.releaseNotes
        descriptionLabel.text = selectApp.description
        
    }
    
    func setNavigationBar() {
        guard let selectApp else { return }
        title = selectApp.trackName
        navigationController?.navigationBar.prefersLargeTitles = false
        
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
