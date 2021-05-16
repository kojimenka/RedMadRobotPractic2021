//
//  SignUpSecondVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 19.04.2021.
//

import UIKit

protocol SignUpSecondScreenDelegate: AnyObject {
    func currentStatus(isUserFillScreen: Bool)
}

final class SignUpSecondVC: UIViewController {

    // MARK: - IBOutlet
    
    @IBOutlet private weak var registrationView: NewRegistrationView!
    
    // MARK: - Private Properties
    
    weak private var delegate: SignUpSecondScreenDelegate?
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

    public func checkForWarnings() {
        registrationView.checkForWarning(controller: self)
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        registrationView.delegate = self
        registrationView.addRegistrationFields(registrationDataViewModel.allRegistrationFieldData)
    }
    
}

// MARK: - RegistrationView Delegate

extension SignUpSecondVC: NewRegistrationViewDelegate {
    func currentStatus(isUserFillScreen: Bool) {
        delegate?.currentStatus(isUserFillScreen: isUserFillScreen)
    }
    
    func successFillData(with allRegistrationFieldData: [RegistrationFieldData]) {
        registrationDataViewModel.fillNewValues(with: allRegistrationFieldData)
    }
}
