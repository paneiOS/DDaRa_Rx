//
//  FavoriteListViewModel.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/29.
//

import RxSwift

struct FavoriteListViewModel: ViewModel {
    let model: DefaultStationsUseCase
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let cellSelected: Observable<StationCellData>
    }
    
    struct Output {
        let stations: Observable<[StationCellData]>
        let cellSelected: Observable<StationCellData>
        let alertSheet: Observable<AlertSheet>
        let errorMessage: Observable<Alert?>
    }
    
    init(model: DefaultStationsUseCase) {
        self.model = model
    }

    func transform(input: Input) -> Output {
        let fetching = input.viewWillAppear
            .flatMapLatest(model.getStationList)
            .share()
        
        let stations = fetching
            .map(model.getStationValue)
            .map(model.listToCellData)
        
        let errorMessage = fetching
            .map(model.getStationError)
        
        let alertSheet = input.cellSelected
            .map { data -> AlertSheet in
                return (title: nil, message: nil, actions: [.play, .cancel], style: .actionSheet, data: data)
            }
        
        return Output(stations: stations, cellSelected: input.cellSelected, alertSheet: alertSheet, errorMessage: errorMessage)    
    }
}
