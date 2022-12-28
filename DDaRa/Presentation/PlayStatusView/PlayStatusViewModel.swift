//
//  PlayStatusViewModel.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/22.
//

import RxSwift
import RxCocoa
import Foundation


class PlayStatusViewModel {
    let disposeBag = DisposeBag()
    private let network = StationNetwork()
    
    let playStart = PublishRelay<Void>()
    let stationSelected = PublishRelay<StationCellData>()
    
    let stationInfo: Driver<StationCellData>
    let streamURL: Observable<URL?>
    
    init() {
        stationInfo = stationSelected
            .asDriver(onErrorJustReturn: StationCellData(name: "", imageURL: "", streamURL: "", like: false))
        
        streamURL = stationSelected
            .map { station -> URL? in
                return URL(string: station.streamURL)
            }
    }
}
