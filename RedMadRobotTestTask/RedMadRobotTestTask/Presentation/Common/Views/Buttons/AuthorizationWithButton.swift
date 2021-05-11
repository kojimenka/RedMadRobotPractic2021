//
//  AuthorizationWithButton.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

@IBDesignable
final class AuthorizationWithButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        layer.masksToBounds = true
        layer.cornerRadius = frame.height * 0.25
        
        layer.borderWidth = 1.0
        layer.borderColor = ColorPalette.templatesTintColor?.cgColor
        backgroundColor = .white
    }
    
}
