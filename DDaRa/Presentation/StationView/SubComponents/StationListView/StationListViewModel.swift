//
//  StationListViewModel.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/21.
//

import RxSwift
import RxCocoa

struct StationListViewModel {
    let stationListCellData = PublishRelay<[StationCellData]>()
    let selectedCell = PublishRelay<Void>()
    let reloadCellData = PublishRelay<Void>()
    
    let cellData: Driver<[StationCellData]>
    
    init() {
        cellData = Observable
            .combineLatest(stationListCellData, reloadCellData) { data, _ in
                return data
            }
            .asDriver(onErrorJustReturn: [])
    }
}
