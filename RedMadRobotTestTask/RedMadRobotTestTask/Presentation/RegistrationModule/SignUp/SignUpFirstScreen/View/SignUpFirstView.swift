//
//  SignUpFirstView.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 19.04.2021.
//

import UIKit

@IBDesignable
final class SignUpFirstView: RegistrationView {
    
    // MARK: - IBOutlet
    
    @IBOutlet private var contentView: UIView!
    
    @IBOutlet private weak var loginTextView: AuthorizationTextField!
    @IBOutlet private weak var emailTextView: AuthorizationTextField!
    @IBOutlet private weak var passwordTextView: AuthorizationTextField!
    
    // MARK: - Private Properties
    
    private let passwordValidator = RegistrationPasswordValidator().validator
    private let emailValidator = RegistrationEmailValidator().validator
    private let loginValidator = RegistrationLoginValidator().validator
    
    private var isScreenFilled: Bool = false {
        didSet {
            if isScreenFilled != oldValue {
                isUserFillScreen = isScreenFilled // Change Value in root class
            }
        }
    }
    
    private var isEmailValid = false
    private var isPasswordValid = false
    private var isLoginValid = false
    
    // MARK: - Initializers
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    // MARK: - UIView(RegistrationView)
    
    override func setupValidators() {
        stringValidators = Validated([loginValidator, emailValidator, passwordValidator])
    }
    
    override func changeText(view: AuthorizationTextField, text: String) {
        switch view {
        case emailTextView:
            isEmailValid = emailValidator.isValid(value: text)
        case passwordTextView:
            isPasswordValid = passwordValidator.isValid(value: text)
        case loginTextView:
            isLoginValid = loginValidator.isValid(value: text)
        default:
            return
        }
        
        isScreenFilled = isEmailValid && isPasswordValid && isLoginValid
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        Bundle.main.loadNibNamed(R.nib.signUpFirstView.name, owner: self)
        self.translatesAutoresizingMaskIntoConstraints = false
        contentView.setInView(self)
        setupTextView()
    }
    
    private func setupTextView() {
        loginTextView.setupView(subscriber: self, placeholder: R.string.localizable.signUpLoginPlaceHolder())
        emailTextView.setupView(subscriber: self, placeholder: R.string.localizable.signUpEmailPlaceHolder())
        passwordTextView.setupView(subscriber: self, placeholder: R.string.localizable.signUpPasswordPlaceHolder())
        passwordTextView.isSecureText = true
    }
    
}
