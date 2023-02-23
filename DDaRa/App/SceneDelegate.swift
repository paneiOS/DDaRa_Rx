//
//  SceneDelegate.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var appFlowCoordinator: AppFlowCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        let rootViewController = MainTabBarController()
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        
        appFlowCoordinator = AppFlowCoordinator(mainTabBarController: rootViewController)
        appFlowCoordinator?.start()
    }
}

