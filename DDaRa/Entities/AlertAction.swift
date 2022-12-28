//
//  AlertAction.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/22.
//

import UIKit

protocol AlertActionConvertible {
    var title: String { get }
    var style: UIAlertAction.Style { get }
}

typealias Alert = (title: String?, message: String?, actions: [AlertAction], style: UIAlertController.Style)

enum AlertAction: AlertActionConvertible {
    case play, cancel
    
    var title: String {
        switch self {
        case .play:
            return "재생"
        case .cancel:
            return "취소"
        }
    }
    
    var style: UIAlertAction.Style {
        switch self {
        case .play:
            return .default
        case .cancel:
            return .cancel
        }
    }
    
}
