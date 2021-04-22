//
//  SignUpSecondView.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 19.04.2021.
//

import UIKit

final class SignUpSecondView: RegistrationView {
    
    // MARK: - Properties
    @IBOutlet private var contentView: UIView!
    
    @IBOutlet private weak var nameTextField: AuthorizationTextField!
    @IBOutlet private weak var birthDayTextField: AuthorizationTextField!
    @IBOutlet private weak var cityTextField: AuthorizationTextField!

    private let nameValidator: NameValidator = RegistrationNameValidator()
    private let dateValidator: DayValidator = RegistrationBirthdayValidator()
    private let cityValidator: CityValidator = RegistrationCityValidator()
    
    private var isScreenFilled: Bool = false {
        didSet {
            if isScreenFilled != oldValue {
                isUserFillScreen = isScreenFilled // Change Value in root class
            }
        }
    }
    
    private var isNameFilled: Bool = false {
        didSet {
            checkFullValidation()
        }
    }
    
    private var isBirthDayFilled: Bool = false {
        didSet {
            checkFullValidation()
        }
    }
    
    private var isCityFilled: Bool = false {
        didSet {
            checkFullValidation()
        }
    }
    
    // MARK: - Init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
        allValidators = [nameValidator, dateValidator, cityValidator]
    }
    
    // MARK: - Methods
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
    
    // MARK: - Validation
    override func changeText(view: AuthorizationTextField, text: String) {
        switch view {
        case nameTextField:
            isNameFilled = nameValidator.checkName(name: text)
        case birthDayTextField:
            isBirthDayFilled = dateValidator.checkDay(date: Date())
        case cityTextField:
            isCityFilled = cityValidator.checkCity(city: text)
        default:
            return
        }
    }
    
    private func checkFullValidation() {
        isScreenFilled = isNameFilled && isBirthDayFilled && isCityFilled
    }
}
