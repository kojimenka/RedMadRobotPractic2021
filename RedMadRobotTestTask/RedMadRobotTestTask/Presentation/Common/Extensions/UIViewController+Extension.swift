//
//  UIViewController+Extension.swift
//  Highlights
//
//  Created by Дмитрий Марченков on 07.04.2021.
//

import UIKit

import SafariServices

extension UIViewController {
    func showAlert(alertText: String,
                   alertMessage: String? = nil,
                   buttonTitle: String? = "ОK",
                   action: (() -> Void)? = nil) {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default) { _ in
            if let action = action { action() }
        })
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Present Safari
extension UIViewController {
    func presentSafari(with link: String) {
        guard let url = URL(string: link) else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension UIViewController {
    var navBarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    var topSafeAreaInset: CGFloat {
        let window = UIApplication.shared.keyWindow
        let topPadding = window?.safeAreaInsets.top
        return topPadding ?? 0.0
    }
}

// MARK: - Helpful Childs Extension
extension UIViewController {
    func addChild (controller: UIViewController, rootView: UIView) {
        DispatchQueue.main.async { [self] in
            addChild(controller)
            rootView.addSubview(controller.view)
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                controller.view.topAnchor.constraint(equalTo: rootView.topAnchor),
                controller.view.leadingAnchor.constraint(equalTo: rootView.leadingAnchor),
                controller.view.trailingAnchor.constraint(equalTo: rootView.trailingAnchor),
                controller.view.bottomAnchor.constraint(equalTo: rootView.bottomAnchor)
            ])
            controller.didMove(toParent: self)
        }
    }
    
    func changeChildWithAnimation(newChild: UIViewController) {
        DispatchQueue.main.async { [self] in
            UIView.AnimationTransition.removeAllSubviews(rootView: view)
            addChild(controller: newChild, rootView: view)
        }
        
//        guard children.count > 2 else { return }
//
//        for i in (0...children.count - 2).reversed() {
//            children[i].willMove(toParent: nil)
//            children[i].view.removeFromSuperview()
//            children[i].removeFromParent()
//        }
    }
    
    func removeChild(childController: UIViewController) {
        childController.willMove(toParent: nil)
        childController.view.removeFromSuperview()
        childController.removeFromParent()
    }
    
    func addChildControllerToScrollView(child: UIViewController, scrollView: UIScrollView) {
        child.willMove(toParent: self)
        addChild(child)
        child.didMove(toParent: self)
        scrollView.addSubview(child.view)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController {
    func showErrorAlert(with error: Error) {
        let alert = UIAlertController.createAlert(alertText: error.localizedDescription)
        self.present(alert, animated: true)
    }
}
