//
//  UITabBarController+Rx.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/27.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UITabBarController {
    public var presentAlert: Binder<String> {
        return Binder(base) { base, message in
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(action)
            
            base.present(alertController, animated: true, completion: nil)
        }
    }
    
    public var selectTabBarItem: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.select)).map { _ in }
        return ControlEvent(events: source)
    }
}
