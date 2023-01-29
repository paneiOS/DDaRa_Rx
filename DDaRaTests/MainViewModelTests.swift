//
//  MainViewModelTests.swift
//  DDaRaTests
//
//  Created by 이정환 on 2022/12/28.
//

import XCTest
import Nimble
import RxSwift
import RxTest

@testable import DDaRa

final class MainViewModelTests: XCTestCase {
    private var disposeBag = DisposeBag()
    
    private let stubNetwork = StationNetworkStub()
    
    private var model: DefaultStationsUseCase!
    private var stationList: [Station]!

    override func setUp() {
        self.model = DefaultStationsUseCase(network: stubNetwork)
        let sampleData = StationAPI.getStations.sampleData
        let expectedStationList: [Station] = Dummy().load(sampleData)
        self.stationList = expectedStationList
    }
    
    func testPlayStreamUrl() {
        let scheduler = TestScheduler(initialClock: 0)
        
        let dummyDataEvent = scheduler.createHotObservable([
            .next(0, model.listToSampleCellData(stationList))
        ])
        
        let stationListData = PublishSubject<[StationCellData]>()
        dummyDataEvent
            .subscribe(stationListData)
            .disposed(by: disposeBag)
        
        let itemSelectedEvent = scheduler.createHotObservable([
            .next(1, 0)
        ])
        
        let itemSelected = PublishSubject<Int>()
        itemSelectedEvent
            .subscribe(itemSelected)
            .disposed(by: disposeBag)
        
        let selectedItemStationInfo = itemSelected
            .withLatestFrom(stationListData) { $1[0] }
        
        let selectedStationObserver = scheduler.createObserver(StationCellData.self)
        selectedItemStationInfo
            .subscribe(selectedStationObserver)
            .disposed(by: disposeBag)

        scheduler.start()
        let selectFirstStation = model.listToSampleCellData(stationList)[0]
        
        expect(selectedStationObserver.events).to(
            equal([
                .next(1, selectFirstStation)
            ])
        )
    }
}
