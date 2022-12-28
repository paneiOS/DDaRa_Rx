//
//  FavoriteListBackgroundViewModel.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/28.
//

import RxSwift
import RxCocoa

struct FavoriteListBackgroundViewModel {
    let isStatusLabelHidden: Signal<Bool>
    let shouldHideStatusLabel = PublishSubject<Bool>()
    
    init() {
        isStatusLabelHidden = shouldHideStatusLabel
            .asSignal(onErrorJustReturn: true)
    }
}

