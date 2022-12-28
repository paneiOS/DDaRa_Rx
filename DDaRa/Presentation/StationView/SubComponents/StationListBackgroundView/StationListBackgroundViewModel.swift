//
//  StationListBackgroundViewModel.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/27.
//

import RxSwift
import RxCocoa

struct StationListBackgroundViewModel {
    let isStatusLabelHidden: Signal<Bool>
    let shouldHideStatusLabel = PublishSubject<Bool>()
    
    init() {
        isStatusLabelHidden = shouldHideStatusLabel
            .asSignal(onErrorJustReturn: true)
    }
}

