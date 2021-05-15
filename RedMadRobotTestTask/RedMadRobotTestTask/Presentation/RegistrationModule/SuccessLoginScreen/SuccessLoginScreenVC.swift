//
//  SuccessLoginScreenVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

public protocol SuccessLoginScreenDelegate: AnyObject {
    func presentFeedAction()
}

final class SuccessLoginScreenVC: UIViewController {
    
    // MARK: - Private Properties
    
    weak private var delegate: SuccessLoginScreenDelegate?
    
    // MARK: - Init
    
    init(subscriber: SuccessLoginScreenDelegate?) {
        self.delegate = subscriber
        super.init(nibName: nil, bundle: nil)
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
        delegate?.presentFeedAction()
    }
    
    // MARK: - Private Methods
    
    private func navBarSetup() {
        navigationController?.navigationBar.isHidden = true
    }
    
}
