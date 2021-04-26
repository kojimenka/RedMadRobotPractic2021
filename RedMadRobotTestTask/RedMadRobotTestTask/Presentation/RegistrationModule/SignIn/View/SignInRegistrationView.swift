//
//  SignInRegistrationView.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 19.04.2021.
//

import UIKit

@IBDesignable
final class SignInRegistrationView: RegistrationView {
    
    // MARK: - IBOutlet
    
    @IBOutlet private var contentView: UIView!
    
    @IBOutlet private weak var emailTextView: AuthorizationTextField!
    @IBOutlet private weak var passwordTextView: AuthorizationTextField!
    
    // MARK: - Private Properties
    
    private let emailValidator = RegistrationEmailValidator().validator
    private let passwordValidator = RegistrationPasswordValidator().validator
    
    private var isScreenFilled: Bool = false {
        didSet {
            if isScreenFilled != oldValue {
                isUserFillScreen = isScreenFilled // Change Value in root class
            }
        }
    }
    
    private var isEmailValid = false
    private var isPasswordValid = false
    
    // MARK: - Initializers
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    // MARK: - UIView(RegistrationView)
    
    override func setupValidators() {
        stringValidators = Validated([emailValidator, passwordValidator])
    }
    
    override func changeText(view: AuthorizationTextField, text: String) {
        switch view {
        case emailTextView:
            isEmailValid = emailValidator.isValid(value: text)
        case passwordTextView:
            isPasswordValid = passwordValidator.isValid(value: text)
        default:
            return
        }
        
        isScreenFilled = isEmailValid && isPasswordValid
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        Bundle.main.loadNibNamed(R.nib.signInRegistrationView.name, owner: self)
        self.translatesAutoresizingMaskIntoConstraints = false
        contentView.setInView(self)
        setupTextView()
    }
    
    private func setupTextView() {
        emailTextView.setupView(subscriber: self, placeholder: R.string.localizable.signInEmailPlaceHolder())
        passwordTextView.setupView(subscriber: self, placeholder: R.string.localizable.signInPasswordPlaceHolder())
        passwordTextView.isSecureText = true
    }
    
}
