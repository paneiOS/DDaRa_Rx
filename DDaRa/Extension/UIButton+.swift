//
//  UIButton+.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/22.
//

import UIKit

extension UIButton {
    func setImage(systemName: String, pointSize: CGFloat, state: UIControl.State, weight: UIImage.SymbolWeight = .regular) {
        contentHorizontalAlignment = .center
        contentVerticalAlignment = .center
        imageView?.contentMode = .scaleAspectFit
        setImage(UIImage(systemName: systemName), for: state)
        setPreferredSymbolConfiguration(.init(pointSize: pointSize, weight: weight, scale: .default), forImageIn: .normal)
    }

}

