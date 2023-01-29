//
//  StationAPI.swift
//  DDaRa
//
//  Created by 이정환 on 2023/01/28.
//

import Moya

enum StationAPI {
    case getStations
    case getJsonToUrl(of: URL)
    case getStringToUrl(of: URL)
}

extension StationAPI: TargetType {
    var baseURL: URL {
        switch self {
        case .getStations:
            return URL(string: "https://raw.githubusercontent.com/")!
        case .getJsonToUrl(of: let url), .getStringToUrl(of: let url):
            return url
        }
    }
    
    var path: String {
        switch self {
        case .getStations:
            return "kazamajinz/DDaRa_Rx/2781a73fa8a5875d6001c9b9e5b73ba1b2d78e9c/StationList.json"
        case .getJsonToUrl, .getStringToUrl:
            return ""
        }
    }
    
    var method: Method {
        switch self {
        case .getStations, .getJsonToUrl, .getStringToUrl:
            return .get
        }
    }
    
    var sampleData: Data {
            switch self {
            case .getStations:
                guard let data = Dummy.data(fileName: "networkDummy") else {
                    return Data()
                }
                return data
            case .getJsonToUrl, .getStringToUrl:
                return Data()
            }
        }
    
    var task: Task {
        switch self {
        case .getStations, .getJsonToUrl, .getStringToUrl:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
