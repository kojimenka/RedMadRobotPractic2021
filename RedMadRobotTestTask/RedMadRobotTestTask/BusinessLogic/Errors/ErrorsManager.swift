//
//  ErrorsManager.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 19.04.2021.
//

import UIKit

final class ErrorManager {
    
    // MARK: - Properties
    public static var shared = ErrorManager()
    
    enum CustomErrors {
        case errorWithTitleAndDescription(title: String, description: String)
        case errorWithTitle(title: String)
    }
    
    private init() {}
    
    // MARK: - Methods
    public func presentError(error: CustomErrors) {
        var errorTitle: String
        var errorDescription: String?
        
        switch error {
        case .errorWithTitle(title: let title):
            errorTitle = title
        case .errorWithTitleAndDescription(title: let title, description: let description):
            errorTitle = title
            errorDescription = description
        }
        
        showAlert(alertText: errorTitle, alertMessage: errorDescription)
    }
    
    private func showAlert(alertText: String,
                           alertMessage: String? = nil,
                           buttonTitle: String? = "ОK",
                           action: (() -> Void)? = nil) {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default) { _ in
            if let action = action { action() }
        })
        
        let currentScreen = UIApplication.shared.keyWindow?.rootViewController
        
        currentScreen?.present(alert, animated: true, completion: nil)
    }
    
}
