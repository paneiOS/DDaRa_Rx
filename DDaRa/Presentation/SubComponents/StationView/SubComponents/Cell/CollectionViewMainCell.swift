//
//  CollectionViewMainCell.swift
//  DDaRa
//
//  Created by 이정환 on 2023/01/09.
//

import UIKit
import SnapKit
import Kingfisher

final class CollectionViewMainCell: UICollectionViewCell {
    private lazy var stationImg: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemGray4
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private func setupRound() {
        contentView.layer.cornerRadius = contentView.bounds.size.width / 2
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.backgroundColor = .white
    }
    
    private func updateImage(_ imageName: String) {
        stationImg.kf.setImage(with: URL(string: imageName), placeholder: UIImage(systemName: "photo"))
        contentView.addSubview(stationImg)
        
        stationImg.snp.makeConstraints {
            $0.top.equalToSuperview().offset(1)
            $0.leading.equalToSuperview().offset(1)
            $0.trailing.equalToSuperview().inset(1)
            $0.bottom.equalToSuperview().inset(1)
        }
    }
    
    private func updateShadow() {
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.masksToBounds = false
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        contentView.layer.shadowRadius = 5
        contentView.layer.shadowOpacity = 0.3
    }
    
    func updateUI(imageName: String) {
        updateImage(imageName)
        updateShadow()
        setupRound()
    }
}

