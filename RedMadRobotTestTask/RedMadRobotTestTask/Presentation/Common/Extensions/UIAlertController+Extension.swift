//
//  UIAlertController+Extension.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 25.04.2021.
//

import UIKit

extension UIAlertController {
    static func createAlert(alertText: String,
                            alertMessage: String? = nil,
                            buttonTitle: String? = "ОK") -> UIAlertController {
        
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default) { _ in })
        
        return alert
    }
}
