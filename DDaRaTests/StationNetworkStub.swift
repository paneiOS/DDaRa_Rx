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

class StationNetworkStub: StationNetwork {
    override func getStationList(_ fileName: String) -> Single<Result<StationList, NetworkError>> {
        return Stubber.invoke(getStationList, args: fileName)
    }
}
