//
//  SignUpSecondVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 19.04.2021.
//

import UIKit

final class SignUpSecondVC: UIViewController {

    // MARK: - IBOutlet
    
    @IBOutlet private weak var registrationView: RegistrationView!
    
    // MARK: - Private Properties
    
    private var subscriber: RegistrationViewDelegate?
    
    // MARK: - Initializers
    
    init(subscriber: RegistrationViewDelegate) {
        super.init(nibName: R.nib.signUpSecondVC.name, bundle: R.nib.signUpSecondVC.bundle)
        self.subscriber = subscriber
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registrationView.delegate = subscriber
    }
    
    // MARK: - Public Methods

    public func checkForWarnings() {
        registrationView.checkForWarning(controller: self)
    }
    
}
