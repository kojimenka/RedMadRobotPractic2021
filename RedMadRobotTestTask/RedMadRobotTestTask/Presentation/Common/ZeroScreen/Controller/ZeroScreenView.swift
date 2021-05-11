//
//  ZeroScreenView.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

@IBDesignable
final class ZeroScreenView: UIView {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var zeroImageView: UIImageView!
    @IBOutlet private weak var zeroTitleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var updateButton: UIButton!
    
    // MARK: - Properties
    
    public var buttonAction: (() -> Void)? {
        didSet {
            updateButton.isHidden = buttonAction == nil
        }
    }
    
    private var zeroScreenFabric = ZeroScreenFabric()
    
    // MARK: - Init
    
    init(screenState: ZeroScreenVariations, buttonAction: (() -> Void)? = nil) {
        super.init(frame: .zero)
        self.buttonAction = buttonAction
        setupView()
        setupScreen(state: screenState)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    // MARK: - IBActions
    
    @IBAction private func updateButtonAction(_ sender: Any) {
        buttonAction?()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        Bundle.main.loadNibNamed(R.nib.zeroScreenView.name, owner: self)
        self.translatesAutoresizingMaskIntoConstraints = false
        contentView.setInView(self)
    }
    
    private func setupScreen(state: ZeroScreenVariations) {
        let model = zeroScreenFabric.createZeroModel(state: state)
        
        zeroImageView.image = model.image
        zeroTitleLabel.text = model.titleText
        descriptionLabel.text = model.descriptionText
        updateButton.setTitle(model.buttonTitle, for: .normal)
        
    }
    
}
