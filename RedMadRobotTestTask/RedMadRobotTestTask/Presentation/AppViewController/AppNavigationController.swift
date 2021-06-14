//
//  AppNavigationController.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 08.06.2021.
//

import UIKit

/// Изначально настроенный UINavigationController под дизайн приложения
final class AppNavigationController: UINavigationController {
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }
    
    // MARK: - Private Methods
    
    private func setupNavBar() {
        let font = R.font.ibmPlexSans(size: 17) ?? .init()
        let color = UIColor(hexString: "#DBE3F5")
        
        let attributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        
        navigationBar.titleTextAttributes = attributes
        navigationItem.title = title
        
        // Remove title from back button in navBar
        navigationBar.topItem?.title = ""
    
        navigationBar.tintColor = color
        navigationBar.shadowImage = UIImage()
    }
    
}
