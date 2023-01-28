//
//  FavoriteListView.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class FavoriteListView: UIViewController {
    var viewModel: FavoriteListViewModel!
    var playStatusView: PlayStatusView!
    var backgroundView: FavoriteListBackgroundView!
    private let disposeBag = DisposeBag()
    private let tableView = FavoriteListTableView()
    
    convenience init(playStatusView: PlayStatusView, viewModel: FavoriteListViewModel, backgroundView:  FavoriteListBackgroundView) {
        self.init()
        self.viewModel = viewModel
        self.playStatusView = playStatusView
        self.backgroundView = backgroundView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupAttribute()
        bind()
    }
}

extension FavoriteListView {
    private func bind() {
        let viewWillAppear = rx.viewWillAppear.asObservable()
        let cellSelected = tableView.rx.modelSelected(StationCellData.self).asObservable()
        
        let input = FavoriteListViewModel.Input(viewWillAppear: viewWillAppear, cellSelected: cellSelected)
        let output = viewModel.transform(input: input)
        
        let actionSheetView = ActionSheetView(frame: CGRect(x: 10.0, y: 10.0, width: UIScreen.main.bounds.size.width - 40, height: 120.0))
        actionSheetView.updateUI(to: input.cellSelected)
        
        let alertActionTapped = output.alertSheet
            .flatMapLatest { alert -> Signal<AlertAction> in
                let alertController = UIAlertController(title: "\n\n\n\n\n\n", message: alert.message, preferredStyle: alert.style)
                alertController.view.addSubview(actionSheetView)
                if UIDevice.current.userInterfaceIdiom == .pad {
                    if let popoverController = alertController.popoverPresentationController {
                        popoverController.sourceView = self.view
                        popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                        popoverController.permittedArrowDirections = []
                    }
                }
                return self.presentAlertController(self, alertController, actions: alert.actions)
            }
            .share()
        
        output.stations
            .asDriver(onErrorDriveWith: .empty())
            .drive(tableView.rx.items) { tableView, row, item in
                let index = IndexPath(row: row, section: 0)
                let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteListCell", for: index) as! FavoriteListCell
                cell.updateUI(item)
                return cell
            }
            .disposed(by: disposeBag)
        
        alertActionTapped
            .withLatestFrom(tableView.rx.itemSelected)
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] index in
                self?.tableView.reloadRows(at: [index], with: .automatic)
            })
            .disposed(by: disposeBag)
            
        output.errorMessage
            .asSignal(onErrorSignalWith: .empty())
            .compactMap{$0}
            .emit(to: rx.setAlert)
            .disposed(by: disposeBag)
        
        playStatusView.bind(to: PlayStatusViewModel.PlayInput(stationInfo: cellSelected, alertActionTapped: alertActionTapped))
        
        //MARK: - Background ViewModel
        backgroundView.bind(
            input: output.stations
        )
    }
    
    private func setupAttribute() {
        title = "즐겨찾기"
        view.backgroundColor = .white
        tableView.backgroundView = backgroundView
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
}

extension FavoriteListView: AlertController {}
