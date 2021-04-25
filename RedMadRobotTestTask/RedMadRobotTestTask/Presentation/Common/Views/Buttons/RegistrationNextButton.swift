//
//  RegistrationNextButton.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

@IBDesignable
final class RegistrationNextButton: UIButton {
    
    // MARK: - Properties
    public var isButtonEnable: Bool = true {
        didSet {
            setState(isButtonEnabled: isButtonEnable)
        }
    }
    
    // MARK: - Methods
    override func draw(_ rect: CGRect) {
        layer.masksToBounds = true
        layer.cornerRadius = frame.height * 0.25
    }
    
    private func setState(isButtonEnabled: Bool) {
        let backgroundColor = isButtonEnabled ? R.color.tintOrange() : R.color.light_grey()
        let titleColor = isButtonEnabled ? UIColor.white : R.color.middle_grey()
        
        UIView.AnimationTransition.transitionChangeBackgroundColor(view: self, color: backgroundColor ?? .init())
        UIView.AnimationTransition.transitionChangeButtonTitleColor(button: self, color: titleColor)
    }
    
}
