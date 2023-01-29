//
//  Dummy.swift
//  DDaRaTests
//
//  Created by 이정환 on 2022/12/28.
//

import Foundation

@testable import DDaRa

//var stations: [Station] = Dummy().load("networkDummy.json")

class Dummy {
    func load<T: Decodable>(_ data: Data) -> T {
//        let bundle = Bundle(for: type(of: self))
//
//        guard let file = bundle.url(forResource: filename, withExtension: nil ) else {
//            fatalError("\(filename)을 main bundle에서 불러올 수 없습니다.")
//        }
//
//        do {
//            data = try Data(contentsOf: file)
//        } catch {
//            fatalError("\(filename)을 main bundle에서 불러올 수 없습니다. \(error)")
//        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("파싱할 수 없습니다.")
        }
    }
}

