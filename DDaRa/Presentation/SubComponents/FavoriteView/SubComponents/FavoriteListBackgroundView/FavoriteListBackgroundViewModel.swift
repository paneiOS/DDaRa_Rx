//
//  FavoriteListBackgroundViewModel.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/28.
//

import RxSwift

struct FavoriteListBackgroundViewModel: ViewModel {
    struct Input {
        let favoriteList: Observable<[StationCellData]>
    }
    struct Output {
        let isPlaceHolderHidden: Observable<Bool>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let isPlaceHolderHidden = input.favoriteList
            .map { cellData -> Bool in
                return !cellData.isEmpty
            }
            .asObservable()
        
        return Output(isPlaceHolderHidden: isPlaceHolderHidden)
    }
}
