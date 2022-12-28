//
//  BasicLabel.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/26.
//

import UIKit

class BasicLabel: UILabel {
    init(textColor: UIColor, weight: UIFont.Weight = .medium, size: CGFloat) {
        super.init(frame: .zero)
        setup(textColor, weight, size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(_ textColor: UIColor, _ weight: UIFont.Weight, _ size: CGFloat) {
        self.textColor = textColor
        self.font = UIFont.systemFont(ofSize: size, weight: weight)
        self.adjustsFontSizeToFitWidth = true
    }
}
