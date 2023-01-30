//
//  JSONParser.swift
//  DDaRa
//
//  Created by 이정환 on 2023/01/30.
//

import Foundation

enum JSONParserError: Error, LocalizedError {
    case decodingFail
    case encodingFail
    
    var errorDescription: String? {
        switch self {
        case .decodingFail:
            return "디코딩에 실패했습니다."
        case .encodingFail:
            return "인코딩에 실패했습니다."
        }
    }
}

struct JSONParser<Item: Codable> {
    func decode(from json: Data?) -> Item? {
        guard let data = json else {
            return nil
        }
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Item.self, from: data)
            return decodedData
        } catch DecodingError.dataCorrupted(let context) {
            print(context)
        } catch DecodingError.keyNotFound(let key, let context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch DecodingError.valueNotFound(let value, let context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch DecodingError.typeMismatch(let type, let context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
        }
        
        return nil
    }
}
