//
//  TextStackView.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 23.05.2021.
//

import UIKit

protocol TextStackViewDelegate: AnyObject {
    func userChangeValue(in textFiels: UITextField)
}

final class TextStackView: UIStackView {
    
    // MARK: - Public Properties
    
    weak public var delegate: TextStackViewDelegate?
    
    // MARK: - Init

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Public Methods
    
    public func addRegistrationFields(_ allTextFields: [UITextField]) {
        allTextFields.forEach {
            addArrangedSubview($0)
            $0.addTarget(self, action: #selector(changeText), for: .editingChanged)
        }
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        axis = .vertical
        alignment = .fill
        distribution = .equalSpacing
        spacing = 20
    }
    
    @objc private func changeText(sender: UITextField) {
        delegate?.userChangeValue(in: sender)
    }
    
}
