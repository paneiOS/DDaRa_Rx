//
//  MockURLSession.swift
//  DDaRaTests
//
//  Created by 이정환 on 2023/01/30.
//

import Foundation
@testable import DDaRa

class MockURLSession: URLSessionProtocol {
    
    typealias Response = (data: Data?, urlResponse: URLResponse?, error: Error?)
    
    let response: Response
    
    init(response: Response) {
        self.response = response
    }
    
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        
        return MockURLSessionDataTask(resumeDidCall: {
            completionHandler(self.response.data,
                              self.response.urlResponse,
                              self.response.error)
        })
    }
    
    static func make(url: String, data: Data?, statusCode: Int) -> MockURLSession {
            let mockURLSession: MockURLSession = {
                let urlResponse = HTTPURLResponse(url: URL(string: url)!,
                                               statusCode: statusCode,
                                               httpVersion: nil,
                                               headerFields: nil)
                let mockResponse: MockURLSession.Response = (data: data,
                                                             urlResponse: urlResponse,
                                                             error: nil)
                let mockUrlSession = MockURLSession(response: mockResponse)
                return mockUrlSession
            }()
            return mockURLSession
        }
}

//let sucessResponse = HTTPURLResponse(url: request.url!,
//                                     statusCode: 200,
//                                     httpVersion: nil,
//                                     headerFields: nil)
//let failureResponse = HTTPURLResponse(url: request.url!,
//                                      statusCode: 402,
//                                      httpVersion: nil,
//                                      headerFields: nil)
