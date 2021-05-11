//
//  SuccessLoginScreenVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

public protocol SuccessLoginScreenOutputDelegate: AnyObject {
    func presentAppModule()
}

final class SuccessLoginScreenVC: UIViewController {
    
    // MARK: - Private Properties
    
    weak private var outputDelegate: SuccessLoginScreenOutputDelegate?
    
    // MARK: - Init
    
    init(outputSubscriber: SuccessLoginScreenOutputDelegate?) {
        self.outputDelegate = outputSubscriber
        super.init(
            nibName: R.nib.successLoginScreenVC.name,
            bundle: R.nib.successLoginScreenVC.bundle
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarSetup()
    }
    
    // MARK: - IBAction
    
    @IBAction private func presentFeedAction(_ sender: Any) {
        outputDelegate?.presentAppModule()
    }
    
    // MARK: - Private Methods
    
    private func navBarSetup() {
        navigationController?.navigationBar.isHidden = true
    }
    
}
