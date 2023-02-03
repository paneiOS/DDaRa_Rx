//
//  URLSessionDataTaskProtocol.swift
//  DDaRa
//
//  Created by 이정환 on 2023/01/26.
//

import Foundation

protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

