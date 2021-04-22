//
//  SuccessLoginScreenVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

final class SuccessLoginScreenVC: UIViewController {

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarSetup()
    }
    
    // MARK: - Methods
    @IBAction private func presentFeedAction(_ sender: Any) {
        let tabBarVC = AppTabBarController()
        tabBarVC.modalPresentationStyle = .fullScreen
        navigationController?.present(tabBarVC, animated: true)
    }
    
    private func navBarSetup() {
        navigationController?.navigationBar.isHidden = true
    }
    
}
