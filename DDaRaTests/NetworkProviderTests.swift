//
//  NetworkTests.swift
//  DDaRaTests
//
//  Created by 이정환 on 2023/01/29.
//

import XCTest
import Nimble
import RxSwift

@testable import DDaRa

class NetworkProviderTests: XCTestCase {
    let mockSuccessSession: URLSessionProtocol! = MockURLSession(isRequestSuccess: true)
    let mockFailSession: URLSessionProtocol! = MockURLSession(isRequestSuccess: false)
    var sut_Success: NetworkProvider!
    var sut_Fail: NetworkProvider!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut_Success = NetworkProvider(session: mockSuccessSession)
        sut_Fail = NetworkProvider(session: mockFailSession)
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut_Success = nil
        sut_Fail = nil
        disposeBag = nil
    }
    
    func test_fetchData가_성공했을때_KBS_데이터를_정상으로가져오는지() {
        let expectation = XCTestExpectation(description: "fetchData_KBS_비동기 테스트")
        
        let single = sut_Success.fetchData(stationType: 0, api: StationListAPI(), decodingType: StationList.self).asSingle()
        _ = single.subscribe(onSuccess: { stationList in
            guard let kbsStation = stationList.stationList.first else { return }
            
            expect(kbsStation.section).to(
            equal(Section.지상파),
            description: "KBS의 section은 지상파이다.")
            
            expect(kbsStation.title).to(
            equal("KBS 1라디오"),
            description: "KBS의 title은 KBS 1라디오이다.")
            
            expect(kbsStation.subTitle).to(
            equal("지상파"),
            description: "KBS의 subTitle은 지상파이다.")
            
            expect(kbsStation.stationType).to(
            equal(1),
            description: "KBS의 section은 1이다.")
            
            expect(kbsStation.imageURL).to(
            equal("https://firebasestorage.googleapis.com/v0/b/ddara-fa50b.appspot.com/o/%EB%9D%BC%EB%94%94%EC%98%A4%20%EC%9D%B4%EB%AF%B8%EC%A7%80%2FKBS%201Radio%20Circle%401x.png?alt=media&token=d55137da-926b-444d-b9b7-acb8bce9a085"),
            description: "KBS의 이미지가 제대로 들어오고 있습니다..")
            
            expect(kbsStation.streamURL).to(
            equal("http://serpent0.duckdns.org:8088/kbs1radio.pls"),
            description: "KBS의 StationAPI가 제대로 들어오고 있습니다.")
            
            expectation.fulfill()
        })
        .disposed(by: disposeBag)
    wait(for: [expectation], timeout: 2.0)
    }
    
    func test_fetchData가_실패했을때_정상적으로_에러처리가되는지() {
        let expectation = XCTestExpectation(description: "fetchData_KBS_비동기 테스트")
        
        let single = sut_Fail.fetchData(stationType:0, api: StationListAPI(), decodingType: StationList.self).asSingle()
        _ = single.subscribe(onFailure: { error in
            guard let error = error as? NetworkError else { return }
            expect(error.title).to(
            equal("StatusCodeError"),
            description: "StatusCodeError가 발생하였습니다.")
            
            expectation.fulfill()
        })
        .disposed(by: disposeBag)
    wait(for: [expectation], timeout: 2.0)
    }
}

