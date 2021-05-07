//
//  SignUpSecondView.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 19.04.2021.
//

import UIKit

final class SignUpSecondView: RegistrationView {
    
    // MARK: - IBOutlet
    @IBOutlet private var contentView: UIView!
    
    @IBOutlet private weak var nameTextField: AuthorizationTextField!
    @IBOutlet private weak var birthDayTextField: AuthorizationTextField!
    @IBOutlet private weak var cityTextField: AuthorizationTextField!

    // MARK: - Private Properties

    private let nameValidator: Validator = NameValidator()
    private let cityValidator: Validator = CityValidator()
    
    private var isScreenFilled: Bool = false {
        didSet {
            if isScreenFilled != oldValue {
                isUserFillScreen = isScreenFilled // Change Value in root class
            }
        }
    }
    
    private var isNameValid = false
    private var isCityValid = false
    
    // MARK: - Initializers
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
        allTextFields = [nameTextField, cityTextField]
    }
    
    // MARK: - UIView(RegistrationView)
    
    override func changeText(view: AuthorizationTextField, text: String) throws {
        var validError: Error?
        switch view {
        case nameTextField:
            do {
                isNameValid = try nameValidator.isValid(value: text)
            } catch let error {
                isNameValid = false
                validError = error
            }
        case cityTextField:
            do {
                isCityValid = try cityValidator.isValid(value: text)
            } catch let error {
                isCityValid = false
                validError = error
            }
        default:
            return
        }

        isScreenFilled = isNameValid && isCityValid
        if let validError = validError {
            throw validError
        }
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        Bundle.main.loadNibNamed(R.nib.signUpSecondView.name, owner: self)
        self.translatesAutoresizingMaskIntoConstraints = false
        contentView.setInView(self)
        setupTextView()
    }
    
    private func setupTextView() {
        nameTextField.setupView(subscriber: self, placeholder: "Имя")
        birthDayTextField.setupView(subscriber: self, placeholder: "Дата рождения")
        cityTextField.setupView(subscriber: self, placeholder: "Город")
    }
    
}
