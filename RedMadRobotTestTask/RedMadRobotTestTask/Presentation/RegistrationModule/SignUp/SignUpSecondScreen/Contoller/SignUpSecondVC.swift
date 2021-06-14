//
//  SignUpSecondVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 19.04.2021.
//

import UIKit

protocol SignUpSecondScreenDelegate: AnyObject {
    func currentStatus(isUserFillScreen: Bool)
    func fullUserData(userModel: AddUserInformationModel)
}

final class SignUpSecondVC: UIViewController {

    // MARK: - IBOutlet
    
    /// Кастомный StackView который добавляет textfield-ы c нужными параметрами
    @IBOutlet private weak var registrationView: RegistrationView!
    
    // MARK: - Private Properties
    
    weak private var delegate: SignUpSecondScreenDelegate?
    
    /// ViewModel которая содержит введенные пользователем данные и данные о первоначальной настройки полей
    private let registrationDataViewModel: SecondSignUpRegistrationViewModelProtocol
    
    // MARK: - Initializers
    
    init(
        subscriber: SignUpSecondScreenDelegate,
        registrationDataViewModel: SecondSignUpRegistrationViewModelProtocol = SecondSignUpRegistrationViewModel()
    ) {
        self.registrationDataViewModel = registrationDataViewModel
        super.init(nibName: nil, bundle: nil)
        self.delegate = subscriber
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Public Methods

    /// Проверяем введенные поля на ошибки, если ошибки обнаружены, показываем alert с ошибкой
    public func checkForWarnings() {
        registrationView.checkForWarning(controller: self)
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        /// Настраиваем StackView со всеми полями
        registrationView.delegate = self
        registrationView.addRegistrationFields(registrationDataViewModel.allRegistrationFieldData)
    }
    
}

// MARK: - RegistrationView Delegate

extension SignUpSecondVC: NewRegistrationViewDelegate {
    
    /// Текущий статус заполненотси полей, нужен для активации активации кнопки регистрации
    func currentStatus(isUserFillScreen: Bool) {
        delegate?.currentStatus(isUserFillScreen: isUserFillScreen)
    }
    
    /// Если пользователь успешно ввел все поля, получаем данные с этих полей
    func successFillData(with allRegistrationFieldData: [RegistrationFieldData]) {
        registrationDataViewModel.fillNewValues(with: allRegistrationFieldData)
        delegate?.fullUserData(userModel: registrationDataViewModel.userInfo)
    }
    
}
