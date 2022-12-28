//
//  FavoriteListViewModel.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/26.
//

import Foundation
import RxSwift
import RxCocoa

struct FavoriteListViewModel {
    private let disposeBag = DisposeBag()
    let favoriteListCellData = PublishSubject<[StationCellData]>()
    let selectedCell = PublishRelay<Void>()
    let reloadCellData = PublishRelay<Void>()
    
    let cellData: Driver<[StationCellData]>
    
    init() {
        cellData = reloadCellData
            .withLatestFrom(favoriteListCellData)
            .map {
                return $0.filter {
                    return UserDefaults.standard.bool(forKey: $0.name)
                }
            }
            .asDriver(onErrorJustReturn: [])
    }
}
