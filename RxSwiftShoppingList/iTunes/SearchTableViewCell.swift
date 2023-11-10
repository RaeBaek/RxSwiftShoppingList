//
//  SearchTableViewCell.swift
//  RxSwiftShoppingList
//
//  Created by 백래훈 on 11/8/23.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    let appIconImage = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 10
        view.layer.cornerCurve = .continuous
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray6.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    let appNameLabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .systemFont(ofSize: 17, weight: .medium)
        view.setContentCompressionResistancePriority(.init(749), for: .horizontal)
        return view
    }()

    let receiveButton = {
        let view = UIButton()
        
        var buttonConfig = UIButton.Configuration.filled() //apple system button
        buttonConfig.baseForegroundColor = .systemBlue
        buttonConfig.baseBackgroundColor = .systemGray6
        buttonConfig.cornerStyle = .capsule
        
        var titleAttr = AttributedString.init("받기")
            titleAttr.font = .systemFont(ofSize: 15.0, weight: .bold)
        buttonConfig.attributedTitle = titleAttr
        
        view.configuration = buttonConfig
        return view
    }()
    
    let starImage = {
        let view = UIImageView()
        view.image = UIImage(systemName: "star.fill")
        view.tintColor = .darkGray
        return view
    }()
    
    let starPoint = {
        let view = UILabel()
        view.textColor = .darkGray
        view.font = .systemFont(ofSize: 13, weight: .regular)
        return view
    }()
    
    let developerLabel = {
        let view = UILabel()
        view.textColor = .darkGray
        view.font = .systemFont(ofSize: 13, weight: .regular)
        return view
    }()
    
    let genreLabel = {
        let view = UILabel()
        view.textColor = .darkGray
        view.font = .systemFont(ofSize: 13, weight: .regular)
        return view
    }()
    
    let screenShotStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 10
        view.alignment = .center
        view.distribution = .fillEqually
        return view
    }()
    
    let firstScreenShotImage = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 10
        view.layer.cornerCurve = .continuous
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray6.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    let secondScreenShotImage = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 10
        view.layer.cornerCurve = .continuous
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray6.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    let thirdScreenShotImage = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 10
        view.layer.cornerCurve = .continuous
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray6.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "SearchCell")
        
        configureCell()
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
    }
    
    func configureCell() {
        [appIconImage, appNameLabel, receiveButton, starImage, starPoint, developerLabel, genreLabel, screenShotStackView].forEach {
            contentView.addSubview($0)
        }
        
        [firstScreenShotImage, secondScreenShotImage, thirdScreenShotImage].forEach {
            screenShotStackView.addArrangedSubview($0)
        }
        
    }
    
    func setConstraints() {
        appIconImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(16)
            $0.size.equalTo(60)
        }
        
        appNameLabel.snp.makeConstraints {
            $0.leading.equalTo(appIconImage.snp.trailing).offset(16)
            $0.centerY.equalTo(appIconImage.snp.centerY)
        }
        
        receiveButton.snp.makeConstraints {
            $0.leading.equalTo(appNameLabel.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalTo(appNameLabel.snp.centerY)
            $0.width.equalTo(70)
            $0.height.equalTo(30)
        }
        
        starImage.snp.makeConstraints {
            $0.top.equalTo(appIconImage.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.size.equalTo(15)
        }
        
        starPoint.snp.makeConstraints {
            $0.centerY.equalTo(starImage.snp.centerY)
            $0.leading.equalTo(starImage.snp.trailing).offset(5)
        }
        
        developerLabel.snp.makeConstraints {
            $0.centerY.equalTo(starPoint.snp.centerY)
            $0.centerX.equalToSuperview()
        }
        
        genreLabel.snp.makeConstraints {
            $0.centerY.equalTo(developerLabel.snp.centerY)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        screenShotStackView.snp.makeConstraints {
            $0.top.equalTo(starImage.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(contentView.snp.width).multipliedBy(0.6)
        }
        
    }
    
}
