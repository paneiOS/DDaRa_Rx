//
//  StationListCell.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/21.
//

import UIKit
import SnapKit
import Kingfisher

final class StationListCell: UITableViewCell {
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
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
        layout()
        attribute()
    }
    
    private func layout() {
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
    
    private func attribute() {
        likeButton.addTarget(self, action: #selector(updateButton), for: .touchUpInside)
    }
    
    @objc private func updateButton() {
        guard let name = nameLabel.text else { return }
        likeButton.isSelected = !likeButton.isSelected
        UserDefaults.standard.set(likeButton.isSelected, forKey: name)
    }
    
    func setData(_ data: StationCellData) {
        selectionStyle = .none
        nameLabel.text = data.name
        likeButton.isSelected = UserDefaults.standard.bool(forKey: data.name)
        thumbnailImageView.kf.setImage(with: URL(string: data.imageURL), placeholder: UIImage(systemName: "photo"))
    }
}
