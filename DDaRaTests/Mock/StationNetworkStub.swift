//
//  StationNetworkStub.swift
//  DDaRaTests
//
//  Created by 이정환 on 2022/12/28.
//

import Foundation
import RxSwift
import Stubber

@testable import DDaRa

class StationNetworkStub: NetworkService {
    override func getStationList() -> Single<Result<StationList.Response, NetworkError>> {
        return Stubber.invoke(getStationList, args: nil)
    }
    
    override func getJsonToUrl(of urlString: String) -> Single<Result<URL?, NetworkError>> {
        return Stubber.invoke(getJsonToUrl, args: urlString)
    }
    
    override func getStringToUrl(of urlString: String) -> Single<Result<URL?, NetworkError>> {
        return Stubber.invoke(getStringToUrl, args: urlString)
    }
    
    override func validStreamURL(of urlString: String) -> Single<Result<URL?, NetworkError>> {
        return Stubber.invoke(validStreamURL, args: urlString)
    }
}
