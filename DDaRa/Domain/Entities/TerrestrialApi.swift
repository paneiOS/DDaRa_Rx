//
//  TerrestrialApi.swift
//  DDaRa
//
//  Created by 이정환 on 2023/01/05.
//

//import Foundation

struct TerrestrialApi: Decodable {
    let channelItem: [ServiceUrl]
    
    enum CodingKeys: String, CodingKey {
        case channelItem = "channel_item"
    }
}

struct ServiceUrl: Decodable {
    let serviceUrl: String
    
    enum CodingKeys: String, CodingKey {
        case serviceUrl = "service_url"
    }
}
