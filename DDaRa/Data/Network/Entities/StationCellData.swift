//
//  StationCellData.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/27.
//

import RxDataSources

enum Section: String, Equatable, Codable, CaseIterable, Hashable {
    case 지상파
    case 지역방송
    case 전문방송
    case 음악방송
    case 특별방송
    case BBC
    case 미군방송
    case 국제영화라디오
    case CBS
    case BBS
    case 극동방송
    case 기타종교
    case 교통방송
    
    var id: String {
        return self.rawValue
    }
    var index: Int {
        switch self {
        case .지상파:
            return 0
        case .지역방송:
            return 1
        case .전문방송:
            return 2
        case .음악방송:
            return 3
        case .특별방송:
            return 4
        case .BBC:
            return 5
        case .미군방송:
            return 6
        case .국제영화라디오:
            return 7
        case .CBS:
            return 8
        case .BBS:
            return 9
        case .극동방송:
            return 10
        case .기타종교:
            return 11
        case .교통방송:
            return 12
        }
    }
}

struct StationCellData: Equatable {
    let section: Section
    let title: String
    let subTitle: String
    let stationType: Int
    let imageURL: String
    let imageColor: String
    let streamURL: String
    let detail: String
    let like: Bool
}

struct SectionOfStations {
    var header: String?
    var items: [Item]
}

extension SectionOfStations: SectionModelType {
  typealias Item = StationCellData

   init(original: SectionOfStations, items: [Item]) {
    self = original
    self.items = items
  }
}
