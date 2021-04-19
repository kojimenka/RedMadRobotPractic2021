//
//  SignInRegistrationView.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 19.04.2021.
//

import UIKit

@IBDesignable
final class SignInRegistrationView: RegistrationView {
    
    // MARK: - Properties
    @IBOutlet private var contentView: UIView!
    
    @IBOutlet private weak var emailTextView: AuthorizationTextField!
    @IBOutlet private weak var passwordTextView: AuthorizationTextField!
    
    private let passwordValidator: PasswordValidator = UserRegistrationPasswordValidator()
    private let emailValidator: EmailValidator = UserRegistrationEmailValidator()
    
    private var isScreenFilled: Bool = false {
        didSet {
            if isScreenFilled != oldValue {
                isUserFillScreen = isScreenFilled // Change Value in root class
            }
        }
    }
    
    private var isPasswordFilled: Bool = false {
        didSet {
            checkFullValidation()
        }
    }
    
    private var isEmailFilled: Bool = false {
        didSet {
            checkFullValidation()
        }
    }
    
    // MARK: - Init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
        allValidators = [emailValidator, passwordValidator]
    }
    
    // MARK: - Methods
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
    
    // MARK: - Validation
    override func changeText(view: AuthorizationTextField, text: String) {
        switch view {
        case emailTextView:
            isEmailFilled = emailValidator.checkEmail(email: text)
        case passwordTextView:
            isPasswordFilled = passwordValidator.checkPassword(text: text)
        default:
            return
        }
    }
    
    private func checkFullValidation() {
        isScreenFilled = isPasswordFilled && isEmailFilled
    }
}
