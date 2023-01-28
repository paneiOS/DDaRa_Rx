//
//  CollectionViewBasicCell.swift
//  DDaRa
//
//  Created by 이정환 on 2023/01/16.
//

import UIKit
import SnapKit
import Kingfisher

final class CollectionViewBasicCell: UICollectionViewCell {
    private lazy var view: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
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
        
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.masksToBounds = false
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        contentView.layer.shadowRadius = 5
        contentView.layer.shadowOpacity = 0.3
        
        view.layer.cornerRadius = contentView.bounds.size.width / 2
    }
    
    private func updateImage(_ imageName: String) {
        stationImg.kf.setImage(with: URL(string: imageName), placeholder: UIImage(systemName: "photo"))
        contentView.addSubview(view)
        view.addSubview(stationImg)
        
        view.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        stationImg.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().inset(5)
            $0.bottom.equalToSuperview().inset(5)
        }
    }
    
    private func updateImageColor(_ imageColor: String) {
        contentView.backgroundColor = UIColor(named: imageColor)
    }
    
    func updateUI(imageName: String, imageColor: String) {
        updateImage(imageName)
        updateImageColor(imageColor)
        setupRound()
    }
}

