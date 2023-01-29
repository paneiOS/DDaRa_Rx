//
//  NetworkTests.swift
//  DDaRaTests
//
//  Created by 이정환 on 2023/01/29.
//

import XCTest
import Nimble
import Moya
import RxSwift

@testable import DDaRa

class NetworkProviderTests: XCTestCase {
    func test_sampleData_getStations_비교() throws {
        let disposeBag = DisposeBag()
        let expectation = XCTestExpectation()
        
        let customEndpointClosure = { (target: StationAPI) -> Endpoint in
            return Endpoint(url: URL(target: target).absoluteString,
                            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: nil)
        }
        
        let testingProvider = MoyaProvider<StationAPI>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
        let sampleData = StationAPI
            .getStations
            .sampleData
        let expectedStationList: [Station] = Dummy().load(sampleData)
        
        testingProvider.rx.request(.getStations)
            .map(StationList.Response.self)
            .subscribe{ (result) in
                switch result {
                case .success(let response):
                    expect(response.stationList).to(
                    equal(expectedStationList),
                    description: "getStations의 결과와 sampleData가 같다."
                    )
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                expectation.fulfill()
                
            }
            .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 2.0)
    }
}

