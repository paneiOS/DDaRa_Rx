//
//  NetworkError.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/21.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidStreamURL
    case invalidJSON
    case networkError
    case apiError
    
    var message: String {
        switch self {
        case .apiError:
            return "서버에 문제가 생겼습니다.\n잠시후 다시 시도해주세요."
        case .invalidURL:
            return "서버에 문제가 생겼습니다.\n잠시후 다시 시도해주세요."
        case .invalidStreamURL:
            return "서버에 문제가 생겼습니다.\n잠시후 다시 시도해주세요."
        case .invalidJSON:
            return "서버에 문제가 생겼습니다.\n잠시후 다시 시도해주세요."
        case .networkError:
            return "서버에 문제가 생겼습니다.\n잠시후 다시 시도해주세요."
        }
    }
    
    var title: String {
        switch self {
        case .apiError:
            return "ApiError"
        case .invalidURL:
            return "InvalidURL"
        case .invalidStreamURL:
            return "InvalidStreamURL"
        case .invalidJSON:
            return "InvalidJSON"
        case .networkError:
            return "NetworkError"
        }
    }
}
