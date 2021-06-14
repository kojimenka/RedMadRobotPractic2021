//
//  SignInVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

public protocol SignInDelegate: AnyObject {
    func signUpButtonActionFromSignIn()
    func loginUser(credentials: Credentials)
}

/// Экран с авторизацией пользователя
final class SignInVC: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var enterButton: RegistrationNextButton!
    
    /// Кастомный StackView который добавляет textfield-ы c нужными параметрами
    @IBOutlet private weak var signInView: TextStackView!
    
    /// Изменяем констрейнт при активации клавиатуры
    @IBOutlet private weak var registrationButtonBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Private Properties
    
    weak private var delegate: SignInDelegate?
    
    /// ViewModel которая содержит введенные пользователем данные и данные о первоначальной настройки полей
    private let registrationDataViewModel: SignInRegistrationViewModelProtocol
    
    /// ViewModel для отслеживания клавиатуры
    private let checkKeyboardViewModel: CheckKeyboardViewModel
    
    // MARK: - Init
    
    init(
        subscriber: SignInDelegate?,
        registrationDataViewModel: SignInRegistrationViewModelProtocol = SignInRegistrationViewModel(),
        checkKeyboardViewModel: CheckKeyboardViewModel = CheckKeyboardViewModel()
    ) {
        self.delegate = subscriber
        self.registrationDataViewModel = registrationDataViewModel
        self.checkKeyboardViewModel = checkKeyboardViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBarSetup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - IBAction
    
    @IBAction private func signUpButtonAction(_ sender: Any) {
        delegate?.signUpButtonActionFromSignIn()
    }
    
    @IBAction private func enterButtonAction(_ sender: Any) {
        loginUser()
    }
    
    // MARK: - Private Methods
    
    private func navBarSetup() {
        navigationController?.navigationBar.isHidden = false
        title = R.string.localizable.signInNavBarTitle()
    }
    
    private func setupViews() {
        /// Настраиваем StackView со всеми полями
        signInView.delegate = self
        signInView.addRegistrationFields(registrationDataViewModel.allRegistrationsFields)
        
        /// Настраиваем ViewModel для отслеживания клавиатуры
        checkKeyboardViewModel.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    
    /// Отправляем в контейнер данные для авторизации
    private func loginUser() {
        self.view.endEditing(true)
        delegate?.loginUser(
            credentials: Credentials(
                email: registrationDataViewModel.emailText,
                password: registrationDataViewModel.passwordText
            )
        )
    }
    
}

// MARK: - Check filling state

extension SignInVC: TextStackViewDelegate {

    /// Получаем последние введенные данные от StackView c полями 
    func userChangeValue(in textFiels: UITextField) {
        registrationDataViewModel.fillNewValues(with: textFiels)
    }
    
}

// MARK: - Check Keyboard

extension SignInVC: CheckKeyboardViewModelDelegate {
    
    func keyboardAction(action: KeyboardAction) {
        switch action {
        case .hideKeyboard:
            registrationButtonBottomConstraint.constant = 18
        case .showKeyboard(keyboardHeight: let height):
            registrationButtonBottomConstraint.constant = UIDevice.current.isSmallDevice ? height + 20 : height
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
}
