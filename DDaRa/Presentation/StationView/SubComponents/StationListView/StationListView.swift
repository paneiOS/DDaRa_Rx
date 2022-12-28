//
//  StationListView.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/21.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class StationListView: UITableView {
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: StationListViewModel) {
        viewModel.cellData
            .drive(self.rx.items) { tv, row, data in
                let index = IndexPath(row: row, section: 0)
                let cell = tv.dequeueReusableCell(withIdentifier: "StationListCell", for: index) as! StationListCell
                cell.setData(data)
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        let footer = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.size.width,
            height: UIScreen.main.bounds.size.height / 10
        ))
        footer.backgroundColor = .white
        tableFooterView = footer
        
        register(StationListCell.self, forCellReuseIdentifier: "StationListCell")
        separatorStyle = .singleLine
        rowHeight = UIScreen.main.bounds.size.height / 10
    }
    
    func presentAlertController<Action: AlertActionConvertible>(_ viewController: StationListViewController, _ alertController: UIAlertController, actions: [Action]) -> Signal<Action> {
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
