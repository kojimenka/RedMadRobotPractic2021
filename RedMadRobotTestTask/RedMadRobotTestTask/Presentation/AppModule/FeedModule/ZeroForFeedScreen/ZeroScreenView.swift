//
//  ZeroScreenView.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

protocol ZeroScreenViewDelegate: class {
    func updateButtonAction()
}

@IBDesignable
final class ZeroScreenView: UIView {
    
    // MARK: - Properties
    @IBOutlet private var contentView: UIView!
    weak public var delegate: ZeroScreenViewDelegate?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    // MARK: - Methods
    private func setupView() {
        Bundle.main.loadNibNamed(R.nib.zeroScreenView.name, owner: self)
        self.translatesAutoresizingMaskIntoConstraints = false
        contentView.setInView(self)
    }
    
    @IBAction private func updateButtonAction(_ sender: Any) {
        delegate?.updateButtonAction()
    }
    
}
