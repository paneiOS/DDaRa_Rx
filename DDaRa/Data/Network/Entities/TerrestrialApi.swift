//
//  TerrestrialApi.swift
//  DDaRa
//
//  Created by 이정환 on 2023/01/05.
//

//import Foundation

struct TerrestrialApi: Codable {
    let channelItem: [ServiceUrl]
    
    enum CodingKeys: String, CodingKey {
        case channelItem = "channel_item"
    }
}

struct ServiceUrl: Codable {
    let serviceUrl: String
    
    enum CodingKeys: String, CodingKey {
        case serviceUrl = "service_url"
    }
}
