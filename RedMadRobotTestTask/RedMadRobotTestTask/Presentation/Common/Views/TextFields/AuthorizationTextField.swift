//
//  AuthorizationTextField.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 19.04.2021.
//

import UIKit

enum KeyboardAction {
    case showKeyboard(keyboardHeight: CGFloat)
    case hideKeyboard
}

protocol AuthorizationTextFieldDelegate: AnyObject {
    func changeText(view: AuthorizationTextField, text: String) throws
    func selectedAuthorizationTextField(view: AuthorizationTextField)
    func keyboardHide()
}

@IBDesignable
final class AuthorizationTextField: UIView {
    
    // MARK: - Public Properties
    
    public var isSecureText: Bool? {
        didSet {
            guard let isSecureText = isSecureText else { return }
            textField.isSecureTextEntry = isSecureText
        }
    }
    
    public var currentText: String {
        return textField.text ?? ""
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var indicatorView: UIView!
    
    // MARK: - Private Properties
    
    weak private var delegate: AuthorizationTextFieldDelegate?
    
    // MARK: - Init
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
        setupTextField()
        registerForKeyboardNotification()
    }
    
    // MARK: - Public Methods
    public func setupView(subscriber: AuthorizationTextFieldDelegate, placeholder: String) {
        self.delegate = subscriber
        textField.placeholder = placeholder
    }
    
    public func setState(isSelected: Bool) {
        let neededColor = isSelected ? UIColor.ColorPalette.tintOrangeColor : UIColor.ColorPalette.notActive
        
        UIView.AnimationTransition.transitionChangeBackgroundColor(view: indicatorView,
                                                                   color: neededColor ?? UIColor.clear,
                                                                   duration: 0.25)
    }
    
    // MARK: - Private Methods
    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(kbWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func kbWillHide() {
        delegate?.keyboardHide()
    }
    
    private func setupView() {
        Bundle.main.loadNibNamed(R.nib.authorizationTextField.name, owner: self)
        self.translatesAutoresizingMaskIntoConstraints = false
        contentView.setInView(self)
    }
    
    private func setupTextField() {
        textField.delegate = self
        textField.addTarget(self, action: #selector(changeText), for: .editingChanged)
    }
    
    @objc private func changeText() {
        try? delegate?.changeText(view: self, text: textField.text ?? "")
    }

}

// MARK: - UITextField Delegate
extension AuthorizationTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.selectedAuthorizationTextField(view: self)
    }
    
}
