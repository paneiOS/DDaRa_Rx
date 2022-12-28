//
//  StationListViewController.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class StationListViewController: UIViewController {
    private let disposeBag = DisposeBag()
    let stationListView = StationListView()
    private let backgroundView = StationListBackgroundView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        layout()
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: MainTabBarViewModel) {
        stationListView.bind(viewModel.stationListViewModel)
        backgroundView.bind(viewModel.stationListBackgroundViewModel)
        
        let cellSellected = stationListView.rx.itemSelected.share()
        
        cellSellected.map { _ -> Void in }
            .bind(to: viewModel.stationListViewModel.selectedCell)
            .disposed(by: disposeBag)

        cellSellected.map { $0.row }
            .withLatestFrom(viewModel.stationListViewModel.cellData) { row, stations in
                return stations[row]
            }
            .bind(to: viewModel.playStatusViewModel.stationSelected)
            .disposed(by: disposeBag)
        
        viewModel.shouldPresentAlert
            .flatMapLatest { alert -> Signal<AlertAction> in
                let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: alert.style)
                return self.stationListView.presentAlertController(self, alertController, actions: alert.actions)
            }
            .emit(to: viewModel.alertActionTapped)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        title = "따뜻한 라디오"
        view.backgroundColor = .white
        stationListView.backgroundView = backgroundView
    }
    
    private func layout() {
        view.addSubview(stationListView)
        
        stationListView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
