//
//  StationListBackgroundView.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/27.
//

import UIKit
import RxSwift
import RxCocoa

final class StationListBackgroundView: UIView {
    private let disposeBag = DisposeBag()
    
    private let statusLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: StationListBackgroundViewModel) {
        viewModel.isStatusLabelHidden
            .emit(to: statusLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        backgroundColor = .white
        statusLabel.text = PlaceHolder.stationList.rawValue
        statusLabel.textAlignment = .center
    }
    
    private func layout() {
        addSubview(statusLabel)
        
        statusLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

