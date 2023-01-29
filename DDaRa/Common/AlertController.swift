//
//  AlertController.swift
//  DDaRa
//
//  Created by 이정환 on 2023/01/11.
//

import UIKit
import RxSwift
import RxCocoa

protocol AlertController {
    func presentAlertController<Action: AlertActionConvertible>(_ viewController: UIViewController, _ alertController: UIAlertController, actions: [Action]) -> Signal<Action>
}

extension AlertController {
    func presentAlertController<Action: AlertActionConvertible>(_ viewController: UIViewController, _ alertController: UIAlertController, actions: [Action]) -> Signal<Action> {
        if actions.isEmpty { return .empty() }
        return Observable
            .create { observer in
                for action in actions {
                    alertController.addAction(
                        UIAlertAction(
                            title: action.title,
                            style: action.style,
                            handler: { _ in
                                observer.onNext(action)
                                observer.onCompleted()
                            }
                        )
                    )
                }
                
                viewController.present(alertController, animated: true)

                return Disposables.create {
                    alertController.dismiss(animated: true)
                }
            }
            .asSignal(onErrorSignalWith: .empty())
    }
}
