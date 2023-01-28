//
//  SceneDelegate.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/21.
//

import UIKit
import GoogleMobileAds

class SceneDelegate: UIResponder, UIWindowSceneDelegate, GADFullScreenContentDelegate {
    
    var window: UIWindow?
    var appFlowCoordinator: AppFlowCoordinator?
    var appOpenAd: GADAppOpenAd?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        let rootViewController = MainTabBarController()
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        
        appFlowCoordinator = AppFlowCoordinator(mainTabBarController: rootViewController)
        appFlowCoordinator?.start()
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        requestAppOpenAd()
    }
    
    func requestAppOpenAd() {
        let request = GADRequest()
        GADAppOpenAd.load(withAdUnitID: Constants.GoogleAds.openAdKey,
                          request: request,
                          orientation: UIInterfaceOrientation.portrait,
                          completionHandler: { (appOpenAdIn, _) in
            self.appOpenAd = appOpenAdIn
            guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return
            }
            guard let firstWindow = firstScene.windows.first else {
                return
            }
            guard let topViewController = firstWindow.rootViewController else {
                return
            }
            guard let gOpenAd = self.appOpenAd else {
                return
            }
            gOpenAd.present(fromRootViewController: topViewController)
            self.appOpenAd?.fullScreenContentDelegate = self
            print("Ad is ready")
        })
    }
}

