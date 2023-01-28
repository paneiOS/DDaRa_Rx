//
//  FavoriteListCell.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/26.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

final class FavoriteListCell: UITableViewCell {
    private let disposeBag = DisposeBag()
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemGray4
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .red
        button.setImage(systemName: "heart", pointSize: 200, state: .normal)
        button.setImage(systemName: "heart.fill", pointSize: 200, state: .selected)
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
        setupAttribute()
    }
    
    private func setupLayout() {
        [thumbnailImageView, nameLabel, likeButton].forEach {
            addSubview($0)
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.width.equalTo(thumbnailImageView.snp.height)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(10)
            $0.bottom.equalToSuperview()
        }
        
        likeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalTo(nameLabel.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
            $0.width.equalTo(likeButton.snp.height)
        }
    }
    
    private func setupAttribute() {
        likeButton.addTarget(self, action: #selector(updateButton), for: .touchUpInside)
    }
    
    @objc private func updateButton() {
        guard let name = nameLabel.text else { return }
        likeButton.isSelected = !likeButton.isSelected
        UserDefaults.standard.set(likeButton.isSelected, forKey: name)
        if likeButton.isSelected {
            let count = UserDefaults.standard.integer(forKey: "favoriteCount")
            UserDefaults.standard.set(count + 1, forKey: "favoriteCount")
        }
    }
    
    func updateUI(_ data: StationCellData) {
        selectionStyle = .none
        nameLabel.text = data.title
        likeButton.isSelected = UserDefaults.standard.bool(forKey: data.title)
        thumbnailImageView.kf.setImage(with: URL(string: data.imageURL), placeholder: UIImage(systemName: "photo"))
        thumbnailImageView.backgroundColor = UIColor(named: data.imageColor)
    }
}

