//
//  MainModel.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/21.
//

import Foundation
import RxSwift

struct MainModel {
    let network: NetworkProvider
    
    init(network: NetworkProvider) {
        self.network = network
    }
    
    func getStationList() -> Single<Result<StationList.Response, NetworkError>> {
        return network.getStationList()
    }
    
    func getSectionOfStationValue(_ result: Result<StationList.Response, NetworkError>) -> [Station]? {
        guard case let .success(value) = result else {
            return nil
        }
        return value.stationList
    }
    
    func getStationValue(_ result: Result<StationList.Response, NetworkError>) -> [Station]? {
        guard case let .success(value) = result else {
            return nil
        }
        return value.stationList
    }
    
    func getStationError(_ result: Result<StationList.Response, NetworkError>) -> Alert? {
        guard case .failure(let error) = result else {
            return nil
        }
        return (title: error.title, message: error.message)
    }
    
    func sectionOfCellData(_ data: [Station]?) -> [SectionOfStations] {
        guard let data = data else {
            return []
        }
        
        let tempArray = data.map {
            let bool = UserDefaults.standard.bool(forKey: $0.title)
            return StationCellData(section: $0.section,
                                   title: $0.title,
                                   subTitle: $0.subTitle,
                                   stationType: $0.stationType ?? 0,
                                   imageURL: $0.imageURL,
                                   imageColor: $0.imageColor ?? "white",
                                   streamURL: $0.streamURL,
                                   detail: $0.detail,
                                   like: bool)
        }
        return Dictionary(grouping: tempArray) { $0.section }
            .map {
                SectionOfStations(header: $0.key.id, items: $0.value)
            }
            .sorted {
                Section(rawValue: $0.header ?? "")?.index ?? 0 < Section(rawValue: $1.header ?? "")?.index ?? 0
            }
    }
    
    func listToCellData(_ data: [Station]?) -> [StationCellData] {
        guard let data = data else {
            return []
        }
        
        return data
            .filter { UserDefaults.standard.bool(forKey: $0.title) }
            .map {
                StationCellData(section: $0.section,
                                title: $0.title,
                                subTitle: $0.subTitle,
                                stationType: $0.stationType ?? 0,
                                imageURL: $0.imageURL,
                                imageColor: $0.imageColor ?? "white",
                                streamURL: $0.streamURL,
                                detail: $0.detail,
                                like: true)
            }
    }
    
    func listToSampleCellData(_ data: [Station]?) -> [StationCellData] {
        guard let data = data else {
            return []
        }
        
        return data
            .map {
                StationCellData(section: $0.section,
                                title: $0.title,
                                subTitle: $0.subTitle,
                                stationType: $0.stationType ?? 0,
                                imageURL: $0.imageURL,
                                imageColor: $0.imageColor ?? "white",
                                streamURL: $0.streamURL,
                                detail: $0.detail,
                                like: true)
            }
    }
    
    func getStreamUrlValue(_ result: Result<URL?, NetworkError>) -> URL? {
        guard case let .success(value) = result else {
            return nil
        }
        return value
    }
    
    func getStreamUrlError(_ result: Result<URL?, NetworkError>) -> Alert? {
        guard case .failure(let error) = result else {
            return nil
        }
        return (title: error.title, message: error.message)
    }
    
    func getStringToUrl(of urlString: String) -> Single<Result<URL?, NetworkError>> {
        return network.getStringToUrl(of: urlString)
    }
    
    func getJsonToUrl(of urlString: String) -> Single<Result<URL?, NetworkError>> {
        return network.getJsonToUrl(of: urlString)
    }
    
    func getStreamUrl(of info: StationCellData) -> Single<Result<URL?, NetworkError>> {
        switch info.stationType {
        case 1:
            return getStringToUrl(of: info.streamURL)
        case 2:
            return getJsonToUrl(of: info.streamURL)
        default:
            return validStreamURL(of: info.streamURL)
        }
    }
    
    func validStreamURL(of urlString: String) -> Single<Result<URL?, NetworkError>> {
        return network.validStreamURL(of: urlString)
    }
}
