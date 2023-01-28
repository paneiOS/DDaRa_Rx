//
//  FavoriteListBackgroundView.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/28.
//

import UIKit
import RxSwift
import RxCocoa

class FavoriteListBackgroundView: UIView {
    private let disposeBag = DisposeBag()
    var viewModel: FavoriteListBackgroundViewModel!
    
    let statusLabel = UILabel()
    
    convenience init(viewModel: FavoriteListBackgroundViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupAttribute()
        setupLayout()
    }
    
    func bind(input: Observable<[StationCellData]>) {
        let input = FavoriteListBackgroundViewModel.Input(favoriteList: input)
        let output = viewModel.transform(input: input)
        
        output.isPlaceHolderHidden
            .bind(to: statusLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func setupAttribute() {
        backgroundColor = .white
        statusLabel.text = PlaceHolder.favoriteList.rawValue
        statusLabel.textAlignment = .center
    }
    
    private func setupLayout() {
        addSubview(statusLabel)
        
        statusLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}


