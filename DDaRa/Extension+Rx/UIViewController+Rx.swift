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

typealias Alert = (title: String, message: String)
extension Reactive where Base: UIViewController {
    var setAlert: Binder<(title: String, message: String)> {
        return Binder(base) { base, data in
            let alertController = UIAlertController(title: data.title, message: data.message, preferredStyle: .alert)
            let alert = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            alertController.addAction(alert)
            base.present(alertController, animated: true, completion: nil)
        }
    }
}
