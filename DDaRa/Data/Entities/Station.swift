//
//  Station.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/27.
//

import Foundation

struct Station: Decodable, Equatable {
    let section: Section
    let title: String
    let subTitle: String
    let stationType: Int?
    let imageURL: String
    let imageColor: String?
    let streamURL: String
    let detail: String
}
