//
//  RegistrationLoaderView.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 20.04.2021.
//

import UIKit

@IBDesignable
final class RegistrationLoaderView: UIView {
    
    // MARK: - Properties
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var backGroundView: UIView!
    @IBOutlet private weak var activityLoader: UIActivityIndicatorView!
    
    // MARK: - Init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    init() {
        super.init(frame: CGRect())
        self.setupView()
    }
    
    // MARK: - Methods
    private func setupView() {
        Bundle.main.loadNibNamed(R.nib.registrationLoaderView.name, owner: self)
        self.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        contentView.setInView(self)
    }
    
    public func startLoading(with view: UIView) {
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        self.activityLoader.startAnimating()
        UIView.animate(withDuration: 0.3) {
            self.backGroundView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        }
    }
    
    public func endLoading() {
        UIView.animate(withDuration: 0.3) {
            self.backGroundView.backgroundColor = UIColor.clear
        } completion: { _ in
            self.activityLoader.stopAnimating()
            self.removeFromSuperview()
        }
    }
    
}
