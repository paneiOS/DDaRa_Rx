//
//  URLSessionProtocol.swift
//  DDaRa
//
//  Created by 이정환 on 2023/01/26.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }
