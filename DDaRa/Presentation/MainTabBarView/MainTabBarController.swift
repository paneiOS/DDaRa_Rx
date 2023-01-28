//
//  MainTabBarController.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/26.
//

import UIKit
import RxSwift
import GoogleMobileAds
import SnapKit

final class MainTabBarController: UITabBarController {
    var playStatusView: PlayStatusView?
    public lazy var bannerView: GADBannerView = {
        let banner = GADBannerView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        banner.backgroundColor = .red
        return banner
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBannerViewToBottom(with: Constants.GoogleAds.bannerHeight)
    }
}

extension MainTabBarController {
    func setTabBarUI() {
        guard let playStatusView = playStatusView else { return }
        view.addSubview(playStatusView)
        
        playStatusView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bannerView.snp.top)
            $0.height.equalTo(UIScreen.main.bounds.size.height / 10)
        }
    }
}

extension MainTabBarController: GADBannerViewDelegate {
    func setupBannerViewToBottom(with height: CGFloat) {
        let adSize = GADAdSizeFromCGSize(CGSize(width: view.frame.width, height: height))
        bannerView = GADBannerView(adSize: adSize)

        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        
        bannerView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(tabBar.snp.top)
            $0.height.equalTo(height)
        }
        
        bannerView.adUnitID = Constants.GoogleAds.bannerAdKey
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        adViewDidReceiveAd(bannerView)
    }
    
    
    // MARK: - Delegate

    public func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 1) {
            bannerView.alpha = 1
        }
    }
}

