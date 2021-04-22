//
//  SignUpFirstVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 19.04.2021.
//

import UIKit

final class SignUpFirstVC: UIViewController {

    // MARK: - Properties
    @IBOutlet weak private var signUpView: RegistrationView!
    
    private var subscriber: RegistrationViewDelegate?

    // MARK: - Init
    init(subscriber: RegistrationViewDelegate) {
        super.init(nibName: R.nib.signUpFirstVC.name, bundle: R.nib.signUpFirstVC.bundle)
        self.subscriber = subscriber
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpView.delegate = subscriber
    }
    
    public func checkForWarnings() {
        signUpView.checkForWarning()
    }
    
}
