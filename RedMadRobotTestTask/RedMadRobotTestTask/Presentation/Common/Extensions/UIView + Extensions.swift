//
//  UIView + Extensions.swift
//  Highlights
//
//  Created by Дмитрий Марченков on 07.04.2021.
//

import UIKit

extension UIView {
    func animateShow() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1.0
        }
    }
    
    func animateHide() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0.0
        }
    }
}

// MARK: - Shadows
extension UIView {
    func applyShadow(shadowOffSet: CGSize, shadowOpacity: Float, shadowRadius: CGFloat, color: UIColor) {
        layer.shadowColor = color.cgColor
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        layer.shadowOffset = shadowOffSet
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
}
