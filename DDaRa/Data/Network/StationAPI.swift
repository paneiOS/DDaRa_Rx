//
//  StationAPI.swift
//  DDaRa
//
//  Created by 이정환 on 2023/01/28.
//

import Moya

enum StationAPI {
    case getStations
}

extension StationAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://raw.githubusercontent.com/")!
    }
    
    var path: String {
        switch self {
        case .getStations:
            return "kazamajinz/DDaRa_Rx/2781a73fa8a5875d6001c9b9e5b73ba1b2d78e9c/StationList.json"
        }
    }
    
    var method: Method {
        switch self {
        case .getStations:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getStations:
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
