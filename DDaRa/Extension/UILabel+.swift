//
//  UILabel+.swift
//  DDaRa
//
//  Created by 이정환 on 2023/01/11.
//

import UIKit

extension UILabel {
    func setup(_ textColor: UIColor, _ size: CGFloat, _ weight: UIFont.Weight? = nil) {
        self.textColor = textColor
        self.font = UIFont.systemFont(ofSize: size, weight: weight ?? .medium)
        self.adjustsFontSizeToFitWidth = true
    }
}
