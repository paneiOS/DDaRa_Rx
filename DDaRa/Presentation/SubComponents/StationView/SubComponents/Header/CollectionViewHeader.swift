//
//  CollectionViewHeader.swift
//  DDaRa
//
//  Created by 이정환 on 2023/01/09.
//

import UIKit
import SnapKit

final class CollectionViewHeader: UICollectionReusableView {
    let sectionNameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        sectionNameLabel.font = .systemFont(ofSize: 30, weight: .bold)
        sectionNameLabel.textColor = .black
        
        addSubview(sectionNameLabel)
        
        sectionNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(5)
            $00.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
