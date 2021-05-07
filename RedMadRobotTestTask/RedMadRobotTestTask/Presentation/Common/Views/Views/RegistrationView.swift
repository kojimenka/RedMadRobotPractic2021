//
//  RegistrationView.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 19.04.2021.
//

import UIKit

protocol RegistrationViewDelegate: AnyObject {
    func userChangeFillState(isUserFillScreen: Bool)
}

class RegistrationView: UIView {
    
    // MARK: - Public Properties
    weak public var delegate: RegistrationViewDelegate?
    var allTextFields: [AuthorizationTextField] = []
    
    public var isUserFillScreen: Bool = false {
        didSet {
            delegate?.userChangeFillState(isUserFillScreen: isUserFillScreen)
        }
    }
    
    // MARK: - Private Properties
    
    private var currentSelectedTextView: AuthorizationTextField?
    
    // MARK: - Public Methods
    
    public func checkForWarning(controller: UIViewController) {
        for textField in allTextFields {
            do {
                _ = try changeText(view: textField, text: textField.currentText)
            } catch let error {
                let alert = UIAlertController.createAlert(alertText: error.localizedDescription)
                controller.present(alert, animated: true)
            }
        }
    }
    
}

// MARK: - TextField Delegate
extension RegistrationView: AuthorizationTextFieldDelegate {
    
    // This method override in inheritor class
    @objc public func changeText(view: AuthorizationTextField, text: String) throws {}
    
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
