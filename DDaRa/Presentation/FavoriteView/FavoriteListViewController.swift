//
//  FavoriteListViewController.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class FavoriteListViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let favoriteListView = FavoriteListView()
    private let backgroundView = FavoriteListBackgroundView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        layout()
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteListView.reloadData()
    }
    
    func bind(_ viewModel: MainTabBarViewModel) {
        favoriteListView.bind(viewModel.favoriteListViewModel)
        backgroundView.bind(viewModel.favoriteListBackgroundViewModel)
        
        let cellSellected = favoriteListView.rx.itemSelected.share()
        
        cellSellected.map { _ -> Void in }
            .bind(to: viewModel.favoriteListViewModel.selectedCell)
            .disposed(by: disposeBag)

        cellSellected.map { $0.row }
            .withLatestFrom(viewModel.favoriteListViewModel.cellData) { row, stations in
                return stations[row]
            }
            .bind(to: viewModel.playStatusViewModel.stationSelected)
            .disposed(by: disposeBag)
        
        viewModel.shouldPresentAlert
            .flatMapLatest { alert -> Signal<AlertAction> in
                let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: alert.style)
                return self.favoriteListView.presentAlertController(self, alertController, actions: alert.actions)
            }
            .emit(to: viewModel.alertActionTapped)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        title = "즐겨찾기"
        view.backgroundColor = .white
        favoriteListView.backgroundView = backgroundView
    }
    
    private func layout() {
        view.addSubview(favoriteListView)
        
        favoriteListView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
