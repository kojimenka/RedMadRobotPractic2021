//
//  RegistrationView.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 19.04.2021.
//

import UIKit

protocol RegistrationViewDelegate: class {
    func userChangeFillState(isUserFillScreen: Bool)
}

class RegistrationView: UIView {
    
    // MARK: - Properties
    weak public var delegate: RegistrationViewDelegate?
    
    private var currentSelectedTextView: AuthorizationTextField?
    public var allValidators: [Validator] = []
    
    public var isUserFillScreen: Bool = false {
        didSet {
            delegate?.userChangeFillState(isUserFillScreen: isUserFillScreen)
        }
    }
    
    public func checkForWarning() {
        for validator in allValidators {
            if validator.searchForWarnings() {
                return
            }
        }
    }
}

// MARK: - TextField Delegate
extension RegistrationView: AuthorizationTextFieldDelegate {
    
    // This method override in inheritor class
    @objc public func changeText(view: AuthorizationTextField, text: String) {}
    
    func selectedAuthorizationTextField(view: AuthorizationTextField) {
        guard currentSelectedTextView != view else { return }
        
        if let currentSelectedTextView = currentSelectedTextView {
            currentSelectedTextView.setState(isSelected: false)
            self.currentSelectedTextView = view
            self.currentSelectedTextView?.setState(isSelected: true)
        } else {
            currentSelectedTextView = view
            currentSelectedTextView?.setState(isSelected: true)
        }
    }
    
    func keyboardHide() {
        currentSelectedTextView?.setState(isSelected: false)
        currentSelectedTextView = nil
    }
}
