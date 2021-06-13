//
//  ZeroScreenVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.05.2021.
//

import UIKit

final class ZeroScreenVC: UIViewController {
    
    // MARK: - IBOutlets

    @IBOutlet private weak var contentStackView: UIStackView!
    @IBOutlet private weak var zeroImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var updateButton: UIButton!
    
    // MARK: - Public Properties
    
    public var buttonAction: (() -> Void)? {
        didSet {
//            updateButton.isHidden = buttonAction == nil
        }
    }
    
    // MARK: - Private Properties
    
    private var zeroScreenFabric = ZeroScreenFabric()
    private var model: ZeroScreenModel
    
    // MARK: - Init
    
    init(
        zeroScreenModel: ZeroScreenModel,
        buttonAction: (() -> Void)? = nil
    ) {
        self.model = zeroScreenModel
        super.init(nibName: nil, bundle: nil)
        self.buttonAction = buttonAction
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScreen()
    }
    
    // MARK: - IBActions
    
    @IBAction private func updateButtonAction(_ sender: Any) {
        buttonAction?()
    }
    
    private func setupScreen() {
        zeroImageView.image = model.image
        titleLabel.text = model.titleText
        descriptionLabel.text = model.descriptionText
        updateButton.setTitle(model.buttonTitle, for: .normal)
        
        if model.image == nil {
            zeroImageView.isHidden = true
        }
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        contentStackView.setCustomSpacing(0, after: zeroImageView)
        contentStackView.setCustomSpacing(8, after: titleLabel)
    }
}
