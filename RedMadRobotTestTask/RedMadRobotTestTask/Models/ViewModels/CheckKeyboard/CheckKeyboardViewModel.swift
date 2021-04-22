//
//  CheckKeyboardViewModel.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 19.04.2021.
//

import UIKit

protocol CheckKeyboardViewModelDelegate: class {
    func keyboardAction(action: AuthorizationTextField.KeyboardAction)
}

final class CheckKeyboardViewModel {
    
    // MARK: - Properties
    enum KeyboardAction {
        case showKeyboard(keyboardHeight: CGFloat)
        case hideKeyboard
    }
    
    weak public var delegate: CheckKeyboardViewModelDelegate?
    
    // MARK: - Init
    init(subscriber: CheckKeyboardViewModelDelegate?) {
        self.delegate = subscriber
        registerForKeyboardNotification()
    }
    
    // MARK: - Methods
    
    // swiftlint:disable line_length
    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func kbWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardHight = kbFrameSize?.height ?? 0.0
        delegate?.keyboardAction(action: .showKeyboard(keyboardHeight: keyboardHight))
    }
    
    @objc private func kbWillHide() {
        delegate?.keyboardAction(action: .hideKeyboard)
    }
    
}
