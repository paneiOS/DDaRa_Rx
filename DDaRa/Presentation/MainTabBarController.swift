//
//  MainTabBarController.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/26.
//

import UIKit
import RxSwift

final class MainTabBarController: UITabBarController {
    private let disposeBag = DisposeBag()
    private let mainTabBarViewModel = MainTabBarViewModel()
    private let playStatusView = PlayStatusView()
    
    private lazy var stationViewController: UIViewController = {
        let rootViewController = StationListViewController()
        rootViewController.bind(mainTabBarViewModel)
        let viewController = UINavigationController(rootViewController: rootViewController)
        let tabBarItem = UITabBarItem(title: "방송국", image: UIImage(systemName: "radio"), tag: 0)
        viewController.tabBarItem = tabBarItem
        return viewController
    }()
    
    private lazy var favoriteViewController: UIViewController = {
        let rootViewController = FavoriteListViewController()
        rootViewController.bind(mainTabBarViewModel)
        let viewController = UINavigationController(rootViewController: rootViewController)
        let tabBarItem = UITabBarItem(title: "즐겨찾기", image: UIImage(systemName: "heart"), tag: 1)
        viewController.tabBarItem = tabBarItem
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarUI()
        playStatusView.bind(mainTabBarViewModel.playStatusViewModel)
        viewControllers = [stationViewController, favoriteViewController]
        bind()
    }
}

extension MainTabBarController {
    func setTabBarUI() {
        view.addSubview(playStatusView)
        
        playStatusView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(tabBar.snp.top)
            $0.height.equalTo(UIScreen.main.bounds.size.height / 10)
        }
    }
    
    func bind() {
        let observe = Observable
            .merge(rx.viewWillAppear.asObservable(),
                   self.rx.didSelect.map{_ in}.asObservable()
            )
            .share()
        
        observe
            .map { [weak self] _ -> String in
                return self?.mainTabBarViewModel.fileNmae ?? ""
            }
            .bind(to: mainTabBarViewModel.viewWillAppear)
            .disposed(by: disposeBag)
        
        observe
            .bind(to: mainTabBarViewModel.stationListViewModel.reloadCellData)
            .disposed(by: disposeBag)
        
        observe
            .bind(to: mainTabBarViewModel.favoriteListViewModel.reloadCellData)
            .disposed(by: disposeBag)
        
        mainTabBarViewModel.errorMessage
            .emit(to: self.rx.presentAlert)
            .disposed(by: disposeBag)
    }
}

