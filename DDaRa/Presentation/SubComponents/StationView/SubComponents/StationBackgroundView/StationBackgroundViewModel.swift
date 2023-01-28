//
//  StationBackgroundViewModel.swift
//  DDaRa
//
//  Created by 이정환 on 2023/01/25.
//

import RxSwift

struct StationBackgroundViewModel: ViewModel {
    struct Input {
        let stationList: Observable<[SectionOfStations]>
    }
    struct Output {
        let isPlaceHolderHidden: Observable<Bool>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let isPlaceHolderHidden = input.stationList
            .map { cellData -> Bool in
                return !cellData.isEmpty
            }
            .asObservable()
        
        return Output(isPlaceHolderHidden: isPlaceHolderHidden)
    }
}
