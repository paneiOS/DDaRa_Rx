//
//  StationViewModel.swift
//  DDaRa
//
//  Created by 이정환 on 2023/01/09.
//

import RxSwift

struct StationViewModel: ViewModel {
    let model: MainModel
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let cellSelected: Observable<StationCellData>
    }
    
    struct Output {
        let stations: Observable<[SectionOfStations]>
        let cellSelected: Observable<StationCellData>
        let alertSheet: Observable<AlertSheet>
        let errorMessage: Observable<Alert?>
    }

    init(model: MainModel) {
        self.model = model
    }
    
    func transform(input: Input) -> Output {
        let fetching = input.viewWillAppear
            .flatMapLatest(model.getStationList)
            .share()
        
        let stations = fetching
            .map(model.getSectionOfStationValue)
            .map(model.sectionOfCellData)
        
        let errorMessage = fetching
            .map(model.getStationError)

        let alertSheet = input.cellSelected
            .map { data -> AlertSheet in
                return (title: nil, message: nil, actions: [.play, .cancel], style: .actionSheet, data: data)
            }
            .share()
        
        return Output(stations: stations, cellSelected: input.cellSelected, alertSheet: alertSheet, errorMessage: errorMessage)
    }

}
