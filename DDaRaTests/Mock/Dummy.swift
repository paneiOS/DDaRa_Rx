//
//  Dummy.swift
//  DDaRaTests
//
//  Created by 이정환 on 2022/12/28.
//

import Foundation

@testable import DDaRa

class Dummy {
    func load<T: Decodable>(_ data: Data) -> T {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("파싱할 수 없습니다.")
        }
    }
}

