//
//  MainTabBarController.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/26.
//

import UIKit
import RxSwift
import SnapKit

final class MainTabBarController: UITabBarController {
    var playStatusView: PlayStatusView?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MainTabBarController {
    func setTabBarUI() {
        guard let playStatusView = playStatusView else { return }
        view.addSubview(playStatusView)
        
        playStatusView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(tabBar.snp.top)
            $0.height.equalTo(UIScreen.main.bounds.size.height / 10)
        }
    }
}
