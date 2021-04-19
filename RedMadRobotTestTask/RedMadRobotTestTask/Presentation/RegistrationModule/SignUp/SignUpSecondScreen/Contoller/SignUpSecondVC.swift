//
//  SignUpSecondVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 19.04.2021.
//

import UIKit

final class SignUpSecondVC: UIViewController {

    // MARK: - Properties
    @IBOutlet private weak var registrationView: RegistrationView!
    
    private var subscriber: RegistrationViewDelegate?
    
    // MARK: - Init
    init(subscriber: RegistrationViewDelegate) {
        super.init(nibName: R.nib.signUpSecondVC.name, bundle: R.nib.signUpSecondVC.bundle)
        self.subscriber = subscriber
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registrationView.delegate = subscriber
    }

    public func checkForWarnings() {
        registrationView.checkForWarning()
    }
    
}
