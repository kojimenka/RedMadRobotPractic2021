//
//  UIAlertController+Extension.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 25.04.2021.
//

import UIKit

extension UIAlertController {
    
    static func createAlert(
        alertText: String,
        alertMessage: String? = nil,
        buttonTitle: String? = "ОK")
    -> UIAlertController {
        
        let alert = UIAlertController(
            title: alertText,
            message: alertMessage,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default) { _ in })
        
        return alert
    }
    
    static func createAlertWithTwoButtons(
        alertText: String,
        alertMessage: String? = nil,
        confirmButtonTitle: String? = "Ok",
        cancelButtonTitle: String? = "Cancel",
        userChoiceCompletion: @escaping (Bool) -> Void
    ) -> UIAlertController {
        
        let alert = UIAlertController(
            title: alertText,
            message: alertMessage,
            preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: cancelButtonTitle,
                style: .cancel,
                handler: { _ in
                    userChoiceCompletion(false)
                }
            )
        )
        
        alert.addAction(
            UIAlertAction(
                title: confirmButtonTitle,
                style: .default,
                handler: { _ in
                    userChoiceCompletion(true)
                })
        )
        
        return alert
    }
    
}
