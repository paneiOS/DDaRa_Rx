//
//  AppFlowCoordinator.swift
//  DDaRa
//
//  Created by 이정환 on 2023/01/02.
//

import UIKit

final class AppFlowCoordinator {
    private var mainTabBarController: MainTabBarController!
    private var playStatusView: PlayStatusView!
    private var playStatusViewModel: PlayStatusViewModel!
    private var stationView: StationView!
    private var favoriteView: FavoriteListView!
    private var settingViewController: SettingViewController!
    private var settingNavigationController: UINavigationController!
    
    private let networkService = NetworkProvider()
    private let sleepSettingViewController = SleepSettingViewController(timer: RepeatingTimer())
    
    init(mainTabBarController: MainTabBarController) {
        self.mainTabBarController = mainTabBarController
    }
    
    func start() {
        let mainModel = DefaultStationsUseCase(network: networkService)
        playStatusViewModel = PlayStatusViewModel(model: mainModel)
        playStatusView = PlayStatusView(viewModel: playStatusViewModel,
                                            topViewController: mainTabBarController)
        stationView = StationView(playStatusView: playStatusView,
                                      viewModel: StationViewModel(model: mainModel),
                                      backgroundView: StationBackgroundView(viewModel: StationBackgroundViewModel()))
        favoriteView = FavoriteListView(playStatusView: playStatusView,
                                            viewModel: FavoriteListViewModel(model: mainModel),
                                            backgroundView: FavoriteListBackgroundView(viewModel: FavoriteListBackgroundViewModel()))
        let showSleepSettingAction = SleepSettingAction(showSleepSettingViewController: showSleepSetting)
        settingViewController = SettingViewController(playStatusView: playStatusView,
                                                      actions: showSleepSettingAction)
        
        let stationNavigationController = UINavigationController(rootViewController: stationView)
        stationNavigationController.tabBarItem = UITabBarItem(title: "따뜻한 라디오", image: UIImage(systemName: "radio"), tag: 0)
        let favoriteNavigationController = UINavigationController(rootViewController: favoriteView)
        favoriteNavigationController.tabBarItem = UITabBarItem(title: "즐겨찾기", image: UIImage(systemName: "heart"), tag: 1)
        
        settingNavigationController = UINavigationController(rootViewController: settingViewController)
        settingNavigationController.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "gear"), tag: 2)
        
        mainTabBarController.playStatusView = playStatusView
        mainTabBarController.setTabBarUI()
        
        mainTabBarController.viewControllers = [
            stationNavigationController,
            favoriteNavigationController,
            settingNavigationController
        ]
        
        if UserDefaults.standard.integer(forKey: "favoriteCount") != 0 {
            mainTabBarController.selectedViewController = favoriteNavigationController
        }
    }
    
    func showSleepSetting() {
        sleepSettingViewController.pause = pause
        settingNavigationController.pushViewController(sleepSettingViewController, animated: true)
    }
    
    func pause() {
        playStatusView.pause()
        playStatusViewModel.pause()
    }
}
