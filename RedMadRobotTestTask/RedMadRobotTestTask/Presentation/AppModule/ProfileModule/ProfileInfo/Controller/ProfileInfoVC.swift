//
//  ProfileInfoVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 07.05.2021.
//

import UIKit

protocol ProfileInfoDelegate: AnyObject {
    func editProfileAction()
}

final class ProfileInfoVC: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var profileInfoView: UIView!
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var userAgeLabel: UILabel!
    @IBOutlet private weak var userTagLabel: UILabel!
    
    // MARK: - Private Properties
    
    weak private var delegate: ProfileInfoDelegate?
    private var requestViewModel: ProfileInfoRequestViewModelProtocol
    
    // MARK: - Init
    
    init(
        subscriber: ProfileInfoDelegate?,
        requestViewModel: ProfileInfoRequestViewModelProtocol = ProfileInfoRequestViewModel()
    ) {
        self.delegate = subscriber
        self.requestViewModel = requestViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - IBActions
    
    @IBAction private func editButtonAction(_ sender: Any) {
        delegate?.editProfileAction()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        profileInfoView.layer.masksToBounds = true
        profileInfoView.layer.cornerRadius = 24.0
    }
    
}
