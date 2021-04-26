//
//  SignUpFirstVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 19.04.2021.
//

import UIKit

final class SignUpFirstVC: UIViewController {

    // MARK: - IBOutlet
    
    @IBOutlet weak private var signUpView: RegistrationView!
    
    // MARK: - Private Properties
    
    private var subscriber: RegistrationViewDelegate?

    // MARK: - Initializers
    
    init(subscriber: RegistrationViewDelegate) {
        super.init(nibName: R.nib.signUpFirstVC.name, bundle: R.nib.signUpFirstVC.bundle)
        self.subscriber = subscriber
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController(
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpView.delegate = subscriber
    }
    
    // MARK: - Public Methods
    
    public func checkForWarnings() {
        signUpView.checkForWarning(controller: self)
    }
    
}
