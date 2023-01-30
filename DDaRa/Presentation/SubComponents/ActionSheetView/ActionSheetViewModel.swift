//
//  ActionSheetViewModel.swift
//  DDaRa
//
//  Created by 이정환 on 2023/01/04.
//

import RxSwift
import Foundation
import AVFoundation

final class ActionSheetViewModel {
    struct Output {
        let stationInfo: Observable<StationCellData>
    }
    
    let disposeBag = DisposeBag()
    
}
