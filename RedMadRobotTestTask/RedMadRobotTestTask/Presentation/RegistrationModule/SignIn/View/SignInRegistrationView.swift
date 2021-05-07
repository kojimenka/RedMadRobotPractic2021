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
    
    private let emailValidator: Validator = EmailValidator()
    private let passwordValidator: Validator = PasswordValidator()
    
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
        allTextFields = [emailTextView, passwordTextView]
    }
    
    // MARK: - UIView(RegistrationView)
    
    override func changeText(view: AuthorizationTextField, text: String) throws {
        var validError: Error?
        
        switch view {
        case emailTextView:
            do {
                isEmailValid = try emailValidator.isValid(value: text)
            } catch let error {
                isEmailValid = false
                validError = error
            }
        case passwordTextView:
            do {
                isPasswordValid = try passwordValidator.isValid(value: text)
            } catch let error {
                isPasswordValid = false
                validError = error
            }
        default:
            break
        }

        isScreenFilled = isEmailValid && isPasswordValid
        if let validError = validError {
            throw validError
        }
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
