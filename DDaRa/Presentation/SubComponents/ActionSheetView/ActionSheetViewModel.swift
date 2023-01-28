//
//  ActionSheetViewModel.swift
//  DDaRa
//
//  Created by 이정환 on 2023/01/04.
//

import RxSwift
import RxCocoa
import Foundation
import AVFoundation

final class ActionSheetViewModel {
    struct Output {
        let stationInfo: Observable<StationCellData>
//        let alertActionTapped: Signal<AlertAction>
    }
    
    let disposeBag = DisposeBag()
    
}
