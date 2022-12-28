//
//  MainModel.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/21.
//

import Foundation
import RxSwift

struct MainModel {
    let network: StationNetwork
    
    init(network: StationNetwork = StationNetwork()) {
        self.network = network
    }
    
    func getStationList(_ fileName: String) -> Single<Result<StationList, NetworkError>> {
        return network.getStationList(fileName)
    }
    
    func listToCellData(_ data: [Station]) -> [StationCellData] {
        return data.map {
            let bool = UserDefaults.standard.bool(forKey: $0.name)
            return StationCellData(name: $0.name, imageURL: $0.imageURL, streamURL: $0.streamURL, like: bool)
        }
    }
}
