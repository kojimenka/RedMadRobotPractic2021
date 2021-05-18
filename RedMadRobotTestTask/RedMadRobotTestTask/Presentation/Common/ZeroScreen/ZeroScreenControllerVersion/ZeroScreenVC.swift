//
//  ZeroScreenVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.05.2021.
//

import UIKit

final class ZeroScreenVC: UIViewController {
    
    // MARK: - IBOutlets

    @IBOutlet private weak var zeroImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var updateButton: UIButton!
    
    // MARK: - Public Properties
    
    public var buttonAction: (() -> Void)? {
        didSet {
            updateButton.isHidden = buttonAction == nil
        }
    }
    
    // MARK: - Private Properties
    
    private var zeroScreenFabric = ZeroScreenFabric()
    private var screenState: ZeroScreenVariations
    
    // MARK: - Init
    
    init(screenState: ZeroScreenVariations, buttonAction: (() -> Void)? = nil) {
        self.screenState = screenState
        super.init(nibName: nil, bundle: nil)
        self.buttonAction = buttonAction
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen(state: screenState)
    }
    
    // MARK: - IBActions
    
    @IBAction private func updateButtonAction(_ sender: Any) {
        buttonAction?()
    }
    
    private func setupScreen(state: ZeroScreenVariations) {
        let model = zeroScreenFabric.createZeroModel(state: state)

        zeroImageView.image = model.image
        titleLabel.text = model.titleText
        descriptionLabel.text = model.descriptionText
        updateButton.setTitle(model.buttonTitle, for: .normal)        
    }
    
}
