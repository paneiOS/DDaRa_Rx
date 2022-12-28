//
//  MainModelTests.swift
//  DDaRaTests
//
//  Created by 이정환 on 2022/12/28.
//

import XCTest
import Nimble

@testable import DDaRa

final class MainModelTests: XCTestCase {
    private let stubNetwork = StationNetworkStub()
    
    private var stationList: [Station]!
    private var model: MainModel!

    override func setUp() {
        self.model = MainModel(network: stubNetwork)
        self.stationList = stations
    }
    
    private func testListToCellData() {
        let cellData = model.listToCellData(stationList)
        let stationName = stationList.map {$0.name }
        let cellDataLike = cellData.map { UserDefaults.standard.bool(forKey: $0.name) }
        let stationListLike = stationList.map { UserDefaults.standard.bool(forKey: $0.name) }
        
        expect(cellData.map {$0.name}).to(
            equal(stationName),
            description: "StationCellData의 stationName은 stationList의 stationName이다."
        )
        
        expect(cellDataLike).to(
            equal(stationListLike),
            description: "Station의 name값을 Key값으로 cellData의 like에 Bool값이 전달된다."
        )
    }
}
