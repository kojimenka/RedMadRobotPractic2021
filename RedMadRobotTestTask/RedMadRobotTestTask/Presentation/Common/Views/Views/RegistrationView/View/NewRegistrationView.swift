//
//  NewRegistrationView.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 15.05.2021.
//

import UIKit

protocol NewRegistrationViewDelegate: AnyObject {
    func currentStatus(isUserFillScreen: Bool)
    func successFillData(with allRegistrationFieldData: [RegistrationFieldData])
}

final class NewRegistrationView: UIStackView {
    
    // MARK: - Public properties
    
    public var isUserFillScreen: Bool = false {
        didSet {
            if isUserFillScreen != oldValue {
                delegate?.currentStatus(isUserFillScreen: isUserFillScreen)
            }
            
            if isUserFillScreen {
                delegate?.successFillData(with: allRegistrationFieldData)
            }
        }
    }
    
    weak public var delegate: NewRegistrationViewDelegate?
    
    // MARK: - Private properties
    
    private var allRegistrationFieldData = [RegistrationFieldData]()
    
    // MARK: - Init

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Public Methods
    
    public func addRegistrationFields(_ allRegistrationFieldData: [RegistrationFieldData]) {
        self.allRegistrationFieldData = allRegistrationFieldData
        
        for (index, data) in self.allRegistrationFieldData.enumerated() {
            let textField = createAuthorizationTextField(data: data.fieldData)
            self.allRegistrationFieldData[index].textField = textField
            addArrangedSubview(textField)
        }
    }
    
    public func checkForWarning(controller: UIViewController) {
        var isAlertShow = false
        for data in allRegistrationFieldData {
            do {
                _ = try data.validator.isValid(value: data.textField?.text ?? "")
                data.textField?.isValidFill(true)
            } catch let error {
                data.textField?.isValidFill(false)
                guard isAlertShow == false else { continue }
                isAlertShow = true
                controller.showErrorAlert(with: error)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        axis = .vertical
        alignment = .fill
        distribution = .equalSpacing
        spacing = 20
    }
    
    private func createAuthorizationTextField(data: RegistrationTextFieldData) -> NewAuthorizationTextField {
        let textField = NewAuthorizationTextField()
        textField.placeholder = data.placeHolder
        textField.isSecureTextEntry = data.isSecure
        textField.delegate = self
        textField.addTarget(self, action: #selector(changeText), for: .editingChanged)
        return textField
    }
    
    @objc private func changeText(sender: UITextField) {
        for data in allRegistrationFieldData {
            do {
                _ = try data.validator.isValid(value: data.textField?.text ?? "")
            } catch _ {
                isUserFillScreen = false
                return
            }
        }
        
        isUserFillScreen = true
    }
    
}

// MARK: - TextField Delegate

extension NewRegistrationView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        for (index, data) in allRegistrationFieldData.enumerated() where data.textField == textField {
            if index == allRegistrationFieldData.count - 1 {
                textField.resignFirstResponder()
            } else {
                allRegistrationFieldData[index + 1].textField?.returnKeyType = .next
                allRegistrationFieldData[index + 1].textField?.becomeFirstResponder()
            }
        }
        return false
    }
}