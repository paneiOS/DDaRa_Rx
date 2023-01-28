//
//  CollectionViewLabelCell.swift
//  DDaRa
//
//  Created by 이정환 on 2023/01/17.
//

import UIKit
import SnapKit
import Kingfisher

final class CollectionViewLabelCell: UICollectionViewCell {
    private lazy var view: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.setup(.lightGray, 24)
        return label
    }()
    
    private lazy var stationImg: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemGray4
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private func setupRound() {
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        
        contentView.layer.shadowColor = UIColor.black.cgColor // 색깔
        contentView.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
        contentView.layer.shadowRadius = 5 // 반경
        contentView.layer.shadowOpacity = 0.3 // alpha값
        
        contentView.backgroundColor = .white
        
        view.layer.cornerRadius = 10
    }
    
    private func updateImage(_ imageName: String) {
        stationImg.kf.setImage(with: URL(string: imageName), placeholder: UIImage(systemName: "photo"))
        contentView.addSubview(view)
        view.addSubview(stationImg)
        stationImg.addSubview(label)
        
        view.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        stationImg.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(10)
        }
        
        label.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(5)
        }
    }
    
    func updateUI(title: String, imageName: String) {
        label.text = title
        updateImage(imageName)
        setupRound()
    }
}

