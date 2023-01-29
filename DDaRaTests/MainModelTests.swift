//
//  MainModelTests.swift
//  DDaRaTests
//
//  Created by 이정환 on 2022/12/28.
//

import XCTest
import Moya
import Nimble

@testable import DDaRa

final class MainModelTests: XCTestCase {
    private let stubNetwork = StationNetworkStub()
    
    private var stationList: [Station]!
    private var model: DefaultStationsUseCase!

    override func setUp() {
        self.model = DefaultStationsUseCase(network: stubNetwork)
        let sampleData = StationAPI.getStations.sampleData
        let expectedStationList: [Station] = Dummy().load(sampleData)
        self.stationList = expectedStationList
    }
    
    func test_SectionOfCellData() {
        let cellData = model.sectionOfCellData(stationList)
        let sections = Section.allCases.map{$0.id}
        
        expect(cellData.map{$0.header}).to(
            equal(sections),
            description: "stationList의 sections는 document의 sections와 일치한다."
        )
    }
    
    func test_ListToCellData() {
        let cellData = model.listToCellData(stationList)
        let stationName = cellData.map{$0.title}.sorted()
        let stationListLike = stationList.map{$0.title}.filter{UserDefaults.standard.bool(forKey: $0)}.sorted()
        let favoriteCount = UserDefaults.standard.integer(forKey: "favoriteCount")
        
        expect(cellData.map{$0.title}.sorted()).to(
            equal(stationName),
            description: "StationCellData의 stationName은 stationList의 stationName이다."
        )
        
        expect(stationName).to(
            equal(stationListLike),
            description: "cellData의 좋아요와 document의 좋아요가 일치한다."
        )
        
        expect(cellData.count).to(
            equal(favoriteCount),
            description: "앱실행시 즐겨찾기화면으로 이동하기 위해 저장한 즐겨찾기의 수와 cellData의 즐겨찾기 수가 일치한다."
        )
    }
}
