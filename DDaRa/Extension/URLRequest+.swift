//
//  URLRequest+.swift
//  DDaRa
//
//  Created by 이정환 on 2023/01/30.
//

import Foundation

extension URLRequest {
    init?(api: APIProtocol) {
        guard let url = api.url else {
            return nil
        }
        
        self.init(url: url)
        self.httpMethod = "\(api.method)"
    }
}

