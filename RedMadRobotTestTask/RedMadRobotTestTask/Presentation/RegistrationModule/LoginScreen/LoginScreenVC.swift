//
//  LoginScreenVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

public protocol LoginScreenDelegate: AnyObject {
    func signInButtonAction()
    func signUpButtonAction()
}

final class LoginScreenVC: UIViewController {
    
    // MARK: - Private Properties
    
    weak private var delegate: LoginScreenDelegate?
    
    // MARK: - Init
    
    init(delegate: LoginScreenDelegate?) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - IBAction
    
    @IBAction private func enterWithMailOrPhoneButtonAction(_ sender: Any) {
        delegate?.signInButtonAction()
    }
    
    @IBAction private func registrationButtonAction(_ sender: Any) {
        delegate?.signUpButtonAction()
    }
}
