//
//  SignUpFirstVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 19.04.2021.
//

import UIKit

protocol SignUpFirstScreenDelegate: AnyObject {
    func currentStatus(isUserFillScreen: Bool)
    func successFill(userCredentials: Credentials, loginText: String)
}

final class SignUpFirstVC: UIViewController {

    // MARK: - IBOutlet
    
    @IBOutlet weak private var signUpView: NewRegistrationView!
    
    // MARK: - Private Properties
    
    weak private var delegate: SignUpFirstScreenDelegate?
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
    
    public func checkForWarnings() {
        signUpView.checkForWarning(controller: self)
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        signUpView.delegate = self
        signUpView.addRegistrationFields(registrationDataViewModel.allRegistrationFieldData)
    }
    
}

// MARK: - RegistrationView Delegate

extension SignUpFirstVC: NewRegistrationViewDelegate {
    func currentStatus(isUserFillScreen: Bool) {
        delegate?.currentStatus(isUserFillScreen: isUserFillScreen)
    }
    
    func successFillData(with allRegistrationFieldData: [RegistrationFieldData]) {
        registrationDataViewModel.fillNewValues(with: allRegistrationFieldData)
        
        delegate?.successFill(
            userCredentials: registrationDataViewModel.userCredentials,
            loginText: registrationDataViewModel.loginText
        )
    }
}
