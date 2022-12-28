//
//  UIView+.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/22.
//

import UIKit

extension UIView {
    func startRotating(_ startRotateValue: CGFloat? = 0) {
        let kAnimationKey = "rotation"
        if self.layer.animation(forKey: kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = 3.0
            animate.repeatCount = Float.infinity
            animate.fromValue = startRotateValue
            animate.byValue = Float.pi * 2.0
            self.layer.add(animate, forKey: kAnimationKey)
        }
    }

    func stopRotating() {
        let kAnimationKey = "rotation"
        self.layer.removeAnimation(forKey: kAnimationKey)
    }
}
