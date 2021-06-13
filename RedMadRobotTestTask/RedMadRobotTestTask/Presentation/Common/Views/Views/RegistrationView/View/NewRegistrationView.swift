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
    private var currentDatePickerTextField: UITextField?
    
    private var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        if #available(iOS 14, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        picker.datePickerMode = .date
        picker.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200.0)
        return picker
    }()
    
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
        textField.addTarget(self, action: #selector(changeText), for: .editingChanged)
        textField.delegate = self
    
        if data.isDatePickerNeeded {
            textField.inputView = datePicker
            textField.tintColor = .clear

            datePicker.addTarget(self, action: #selector(datePickerChangedDay), for: .valueChanged)
            let doneButton = UIBarButtonItem(
                title: "Done",
                style: .done,
                target: self,
                action: #selector(self.datePickerDone)
            )
            
            let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: 44))
            let batButtonItem = UIBarButtonItem(
                barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                target: nil,
                action: nil)
            
            toolBar.setItems([batButtonItem, doneButton], animated: true)
            
            textField.inputAccessoryView = toolBar
        }
        
        return textField
    }
    
    @objc func datePickerDone() {
        endEditing(true)
     }
    
    @objc private func datePickerChangedDay() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let stringDate = formatter.string(from: datePicker.date)
        currentDatePickerTextField?.text = stringDate
        changeText()
    }
    
    @objc private func changeText() {
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
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        for data in allRegistrationFieldData where data.fieldData.isDatePickerNeeded {
            if data.textField == textField {
                currentDatePickerTextField = textField
            } else {
                currentDatePickerTextField = nil
            }
        }
        return true
    }
    
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
