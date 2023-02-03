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
    var disposeBag: DisposeBag!
    var data: Data!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        disposeBag = DisposeBag()
        data = JsonLoader.data(fileName: "NetworkDummy")
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        disposeBag = nil
        data = nil
    }
    
    func test_fetchData가_있고_statusCode가_200일때() {
        let expectation = XCTestExpectation(description: "fetchData_KBS_비동기 테스트, statusCode가 200이고, 정상일떄")
        let url = "https://raw.githubusercontent.com/"
        let mockURLSession = MockURLSession.make(url: url, data: data, statusCode: 200)
        let sut = NetworkProvider(session: mockURLSession)
        
        let single = sut.fetchData(stationType: 0, api: StationListAPI(), decodingType: StationList.self).asSingle()
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
    
    func test_fetchData에_대한_잘못된_dataType을_넘겼을때() {
        let expectation = XCTestExpectation(description: "fetchData_KBS_비동기 테스트, statusCode가 200이지만, 타입이 잘못되었을때")
        let url = "https://raw.githubusercontent.com/"
        let mockURLSession = MockURLSession.make(url: url, data: data, statusCode: 200)
        let sut = NetworkProvider(session: mockURLSession)
        
        let observable = sut.fetchData(stationType: 0, api: StationListAPI(), decodingType: Station.self).asObservable()
        _ = observable.subscribe(onError: { error in
            guard let error = error as? JSONParserError else { return }
            expect(error).to(
                equal(JSONParserError.decodingFail),
                description: "타입이 일치하지 않아 디코딩에 실패했습니다.")
            
            expectation.fulfill()
        })
        .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_fetchData가_없고_statusCode가_402일때() {
        let expectation = XCTestExpectation(description: "fetchData_KBS_비동기 테스트")
        let url = "https://raw.githubusercontent.com/"
        let mockURLSession = MockURLSession.make(url: url, data: nil, statusCode: 402)
        let sut = NetworkProvider(session: mockURLSession)
        
        let single = sut.fetchData(stationType:0, api: StationListAPI(), decodingType: StationList.self).asSingle()
        _ = single.subscribe(onFailure: { error in
            guard let error = error as? NetworkError else { return }
            expect(error).to(
                equal(NetworkError.statusCodeError),
                description: "StatusCodeError가 발생하였습니다.")
            
            expectation.fulfill()
        })
        .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 2.0)
    }
}

