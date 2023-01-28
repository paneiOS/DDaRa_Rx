//
//  AppDelegate.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/21.
//

import UIKit
import GoogleMobileAds
import AdSupport
import AppTrackingTransparency

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                   if #available(iOS 14, *) {
                       ATTrackingManager.requestTrackingAuthorization { status in
                           switch status {
                           case .authorized:
#if DEBUG
                               print("Authorized")
                               print("IDFA = \(ASIdentifierManager.shared().advertisingIdentifier)")
#endif
                           case .denied:
#if DEBUG
                               print("Denied")
#endif
                           case .notDetermined:
#if DEBUG
                               print("Not Determined")
#endif
                           case .restricted:
#if DEBUG
                               print("Restricted")
#endif
                           @unknown default:
#if DEBUG
                               print("Unknow")
#endif
                           }
                       }
                   }
               }
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
}

