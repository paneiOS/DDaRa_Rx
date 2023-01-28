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
    
    func getStationList() -> Single<Result<StationList, NetworkError>> {
        return network.getStationList()
    }
    
    func listToCellData(_ data: [Station]) -> [StationCellData] {
        return data.map {
            let bool = UserDefaults.standard.bool(forKey: $0.name)
            return StationCellData(section: $0.section,
                                   name: $0.name,
                                   stationType: $0.stationType,
                                   stationAPI: $0.stationAPI,
                                   imageURL: $0.imageURL,
                                   streamURL: $0.streamURL,
                                   like: bool)
        }
    }
    
    func getStreamUrl(to stationType: Int, of urlString: String) -> Single<Result<URL?, NetworkError>> {
        switch stationType {
        case 1:
            return network.getJsonToUrl(of: urlString)
        case 2:
            return network.getStringToUrl(of: urlString)
        default:
            return .just(Result.failure(NetworkError.apiError))
        }
    }
    
    func getJsonToUrl(of urlString: String) -> Single<Result<URL?, NetworkError>> {
        return network.getJsonToUrl(of: urlString)
    }
    
    func getStringToUrl(of urlString: String) -> Single<Result<URL?, NetworkError>> {
        return network.getJsonToUrl(of: urlString)
    }
}
