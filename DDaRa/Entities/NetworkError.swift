//
//  NetworkError.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/21.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidJSON
    case networkError
    
    var message: String {
        switch self {
        case .invalidURL:
            return "라디오 주소에 문제가 생겼습니다."
        case .invalidJSON:
            return "서버에 문제가 생겼습니다."
        case .networkError:
            return "인터넷에 문제가 생겼습니다."
        }
    }
}
