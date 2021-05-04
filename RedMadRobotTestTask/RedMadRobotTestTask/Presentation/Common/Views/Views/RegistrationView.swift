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
    
    public var stringValidators = Validated<String>([])
    public var dateValidators = Validated<Date>([])
    
    public var isUserFillScreen: Bool = false {
        didSet {
            delegate?.userChangeFillState(isUserFillScreen: isUserFillScreen)
        }
    }
    
    // MARK: - Initializers
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupValidators()
    }
    
    // MARK: - Private Properties
    
    private var currentSelectedTextView: AuthorizationTextField?
    
    // MARK: - Public Methods
    
    public func setupValidators() {}
    
    public func checkForWarning(controller: UIViewController) {
        let allErrors = stringValidators.errors + dateValidators.errors
        
        guard let error = allErrors.first else { return }
        let alert = UIAlertController.createAlert(alertText: error.localizedDescription)
        controller.present(alert, animated: true)
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
