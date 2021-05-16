//
//  UIView + Extensions.swift
//  Highlights
//
//  Created by Дмитрий Марченков on 07.04.2021.
//

import UIKit

// MARK: - NibView

class NibView: UIView, NibLoadable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()
    }
    
}

protocol NibLoadable {
    
}

extension NibLoadable where Self: UIView {
    
    func initiateFromNib() -> UIView? {
        let nib = UINib(nibName: String(describing: Self.self), bundle: Bundle(for: Self.self))
        let view = nib.instantiate(withOwner: Self.self, options: nil).first as? UIView
        return view
    }
    
    func loadNibContent() {
        guard let view = initiateFromNib() else { return }
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
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

extension UIView {
    func setInView(_ container: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = container.frame
        container.addSubview(self)
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: container.topAnchor),
            self.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
    }
}

extension UIView {
    func addFillView(view: UIView) {
        addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

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
