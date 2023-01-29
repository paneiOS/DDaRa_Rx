//
//  StationList.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/21.
//

import Foundation

struct StationList: Decodable {
    
    public struct Response: Decodable {
        public let stationList: [Station]
    }
}
