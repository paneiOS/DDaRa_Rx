//
//  StationBackgroundView.swift
//  DDaRa
//
//  Created by 이정환 on 2023/01/25.
//

import UIKit
import RxSwift
import RxCocoa

class StationBackgroundView: UIView {
    private let disposeBag = DisposeBag()
    var viewModel: StationBackgroundViewModel!
    
    let statusLabel = UILabel()
    
    convenience init(viewModel: StationBackgroundViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupAttribute()
        setupLayout()
    }
    
    func bind(input: Observable<[SectionOfStations]>) {
        let input = StationBackgroundViewModel.Input(stationList: input)
        let output = viewModel.transform(input: input)
        
        output.isPlaceHolderHidden
            .bind(to: statusLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func setupAttribute() {
        backgroundColor = .white
        statusLabel.text = PlaceHolder.stationList.rawValue
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


