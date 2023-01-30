//
//  ServiceAPI.swift
//  DDaRa
//
//  Created by 이정환 on 2023/01/30.
//

import Foundation

protocol BaseURLProtocol {
    var baseURL: String { get }
}

protocol APIProtocol {
    var url: URL? { get }
    var method: HttpMethod { get }
}

protocol Gettable: APIProtocol { }

enum HttpMethod {
    case get
    case post
    
    var description: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }
}

struct ServiceAPI: BaseURLProtocol {
    let baseURL = "https://raw.githubusercontent.com/"
}

struct StationListAPI: Gettable {
    let url: URL?
    let method: HttpMethod = .get
    
    init(baseURL: BaseURLProtocol = ServiceAPI()) {
        self.url = URL(string:
                        baseURL.baseURL
                       + "kazamajinz/DDaRa_Rx/main/StationList.json")
    }
}

struct StreamingAPI: Gettable {
    let url: URL?
    let method: HttpMethod = .get
    
    init(of baseURL: URL) {
        self.url = baseURL
    }
}
