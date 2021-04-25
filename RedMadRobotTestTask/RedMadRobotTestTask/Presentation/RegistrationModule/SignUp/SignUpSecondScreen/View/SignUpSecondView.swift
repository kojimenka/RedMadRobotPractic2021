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
    
    private let nameValidator = RegistrationNameValidator().validator
    private let dateValidator = RegistrationBirthdayValidator().validator
    private let cityValidator = RegistrationCityValidator().validator
    
    private var isScreenFilled: Bool = false {
        didSet {
            if isScreenFilled != oldValue {
                isUserFillScreen = isScreenFilled // Change Value in root class
            }
        }
    }
    
    private var isNameValid = false
    private var isBirthDayValid = false
    private var isCityValid = false
    
    // MARK: - Initializers
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    // MARK: - UIView(RegistrationView)
    
    override func setupValidators() {
        stringValidators = Validated([nameValidator, cityValidator])
        dateValidators = Validated([dateValidator])
    }
    
    override func changeText(view: AuthorizationTextField, text: String) {
        switch view {
        case nameTextField:
            isNameValid = nameValidator.isValid(value: text)
        case birthDayTextField:
            isBirthDayValid = dateValidator.isValid(value: Date())
        case cityTextField:
            isCityValid = cityValidator.isValid(value: text)
        default:
            return
        }
        
        isScreenFilled = isNameValid && isBirthDayValid && isCityValid
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
