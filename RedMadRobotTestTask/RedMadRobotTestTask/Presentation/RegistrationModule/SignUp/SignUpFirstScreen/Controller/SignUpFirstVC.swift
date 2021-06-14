//
//  SignUpFirstVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 19.04.2021.
//

import UIKit

protocol SignUpFirstScreenDelegate: AnyObject {
    func currentStatus(isUserFillScreen: Bool)
    func successFill(userCredentials: Credentials)
}

/// Экран с заполнением данных для регистрации
final class SignUpFirstVC: UIViewController {

    // MARK: - IBOutlet
    
    /// Кастомный StackView который добавляет textfield-ы c нужными параметрами
    @IBOutlet weak private var signUpView: RegistrationView!
    
    // MARK: - Private Properties
    
    weak private var delegate: SignUpFirstScreenDelegate?
    
    /// ViewModel которая содержит введенные пользователем данные и данные о первоначальной настройки полей
    private let registrationDataViewModel: FirstSignUpRegistrationViewModelProtocol

    // MARK: - Initializers
    
    init(
        subscriber: SignUpFirstScreenDelegate,
        registrationDataViewModel: FirstSignUpRegistrationViewModelProtocol = FirstSignUpRegistrationViewModel()
    ) {
        self.registrationDataViewModel = registrationDataViewModel
        super.init(nibName: nil, bundle: nil)
        self.delegate = subscriber
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController(
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Public Methods
    
    /// Проверяем введенные поля на ошибки, если ошибки обнаружены, показываем alert с ошибкой
    public func checkForWarnings() {
        signUpView.checkForWarning(controller: self)
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        /// Настраиваем StackView со всеми полями
        signUpView.delegate = self
        signUpView.addRegistrationFields(registrationDataViewModel.allRegistrationFieldData)
    }
    
}

// MARK: - RegistrationView Delegate

extension SignUpFirstVC: NewRegistrationViewDelegate {
    
    /// Текущий статус заполненотси полей, нужен для активации активации кнопки регистрации
    func currentStatus(isUserFillScreen: Bool) {
        delegate?.currentStatus(isUserFillScreen: isUserFillScreen)
    }
    
    /// Если пользователь успешно ввел все поля, получаем данные с этих полей
    func successFillData(with allRegistrationFieldData: [RegistrationFieldData]) {
        registrationDataViewModel.fillNewValues(with: allRegistrationFieldData)
        
        delegate?.successFill(
            userCredentials: registrationDataViewModel.userCredentials
        )
    }
    
}
