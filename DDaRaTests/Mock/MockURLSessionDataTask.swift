//
//  MockURLSessionDataTask.swift
//  DDaRaTests
//
//  Created by 이정환 on 2023/02/03.
//

import Foundation
@testable import DDaRa

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    var resumeDidCall: () -> Void
    
    init(resumeDidCall: @escaping () -> Void) {
        self.resumeDidCall = resumeDidCall
    }
    
    func resume() {
        resumeDidCall()
    }
    
    func cancel() {}
}
