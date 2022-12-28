//
//  Station.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/27.
//

import Foundation

struct Station: Decodable {
    let name: String
    let imageURL: String
    let streamURL: String
    
    init(name: String, imageURL: String, streamURL: String) {
        self.name = name
        self.imageURL = imageURL
        self.streamURL = streamURL
    }
}
