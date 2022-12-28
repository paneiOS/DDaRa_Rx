//
//  UIViewController+Rx.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/27.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    public var viewWillAppear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { _ in }
        return ControlEvent(events: source)
    }
}
