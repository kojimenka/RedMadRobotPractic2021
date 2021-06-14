//
//  UIView + Extensions.swift
//  Highlights
//
//  Created by Дмитрий Марченков on 07.04.2021.
//

import UIKit

// MARK: - UIView Animate

extension UIView {
    func shakeView() {
        let shakeAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        shakeAnimation.duration = 0.7
        shakeAnimation.timingFunctions = [CAMediaTimingFunction(name: .easeOut)]
        shakeAnimation.values = [0.0, -5.0, 5.0, -3.0, 3.0, -2.0, 2.0, 0.0].map { (degres: Double) -> Double in
            let radios = (Double.pi * degres) / 180
            return radios
        }
        
        self.layer.add(shakeAnimation, forKey: "shakeIt")
    }
}

extension UIView {
    
    func animateHide() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0.0
        } completion: { _ in
            self.isHidden = true
        }
    }
    
    func animateShow() {
        self.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1.0
        }
    }
    
}
