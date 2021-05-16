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

final class NewRegistrationView: UIView {
    
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
    
    // MARK: - Views
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        return stackView
    }()
    
    // MARK: - Init
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Public Methods
    
    public func addRegistrationFields(_ allRegistrationFieldData: [RegistrationFieldData]) {
        self.allRegistrationFieldData = allRegistrationFieldData
        
        for (index, data) in self.allRegistrationFieldData.enumerated() {
            let textField = createAuthorizationTextField(data: data.fieldData)
            self.allRegistrationFieldData[index].textField = textField
            stackView.addArrangedSubview(textField)
        }
    }
    
    public func checkForWarning(controller: UIViewController) {
        for data in allRegistrationFieldData {
            do {
                _ = try data.validator.isValid(value: data.textField?.text ?? "")
            } catch let error {
                controller.showErrorAlert(with: error)
                return
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        setConstraints()
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
    
    private func setConstraints() {
        addFillView(view: stackView)
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
