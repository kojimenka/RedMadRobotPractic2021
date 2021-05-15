//
//  SignInViewModel.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

protocol SetupNavBarViewModelProtocol {
    func customizeNavBar(navigationBar: UINavigationBar?, navigationItem: UINavigationItem, title: String)
}

final class SetupNavBarViewModel: SetupNavBarViewModelProtocol {
    
    // MARK: - Methods
    public func customizeNavBar(navigationBar: UINavigationBar?, navigationItem: UINavigationItem, title: String) {
        let font = R.font.ibmPlexSans(size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .regular)
        let color = UIColor(hexString: "#DBE3F5")
        
        let attributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        
        navigationBar?.titleTextAttributes = attributes
        navigationItem.title = title
        
        // Remove title from back button in navBar
        navigationBar?.topItem?.title = ""
        
        navigationBar?.tintColor = color
        navigationBar?.setBackgroundImage(UIImage(), for: .default)
        navigationBar?.shadowImage = UIImage()
    }
    
}
