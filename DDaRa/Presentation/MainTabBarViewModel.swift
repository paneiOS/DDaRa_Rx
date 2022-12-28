//
//  MainTabBarViewModel.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/26.
//

import Foundation
import RxSwift
import RxCocoa

final class MainTabBarViewModel {
    private var disposeBag = DisposeBag()
    
    let playStatusViewModel = PlayStatusViewModel()
    let stationListViewModel = StationListViewModel()
    let favoriteListViewModel = FavoriteListViewModel()
    let stationListBackgroundViewModel = StationListBackgroundViewModel()
    let favoriteListBackgroundViewModel = FavoriteListBackgroundViewModel()
    
    let alertActionTapped = PublishRelay<AlertAction>()
    let shouldPresentAlert: Signal<Alert>
    let viewWillAppear = PublishRelay<String>()
    let errorMessage: Signal<String>
    
    let fileNmae = "test_station"
    
    init(model: MainModel = MainModel()) {
        let radionResult = viewWillAppear
            .flatMapLatest(model.getStationList)
            .share()
        
        let radionResultValue = radionResult
            .compactMap { data -> [StationCellData]? in
                guard case let .success(value) = data else {
                    return nil
                }
                return model.listToCellData(value.stationList)
            }
        
        errorMessage = radionResult
            .compactMap { data -> String? in
                switch data {
                case let .failure(error):
                    return error.message
                default:
                    return nil
                }
            }
            .asSignal(onErrorJustReturn: "잠시 후 다시 시도해주세요.")
        
        radionResultValue
            .bind(to: stationListViewModel.stationListCellData)
            .disposed(by: disposeBag)
        
        radionResultValue
            .map { !$0.isEmpty }
            .bind(to: stationListBackgroundViewModel.shouldHideStatusLabel)
            .disposed(by: disposeBag)
        
        radionResultValue
            .bind(to: favoriteListViewModel.favoriteListCellData)
            .disposed(by: disposeBag)
        
        radionResultValue
            .map { !$0.filter{UserDefaults.standard.bool(forKey: $0.name)}.isEmpty }
            .bind(to: favoriteListBackgroundViewModel.shouldHideStatusLabel)
            .disposed(by: disposeBag)
        
        let stationCellSelected = stationListViewModel.selectedCell
            .map { _ -> Alert in
                return (title: nil, message: nil, actions: [.play, .cancel], style: .actionSheet)
            }
            .asObservable()
        
        let favoriteCellSelected = favoriteListViewModel.selectedCell
            .map { _ -> Alert in
                return (title: nil, message: nil, actions: [.play, .cancel], style: .actionSheet)
            }
            .asObservable()
        
        shouldPresentAlert =
            Observable.merge([stationCellSelected, favoriteCellSelected]).asSignal(onErrorSignalWith: .empty())
        
        alertActionTapped
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .play:
                    self?.playStatusViewModel.playStart.accept(Void())
                case .cancel:
                    return
                }
            })
            .disposed(by: disposeBag)
    }
}
