//
//  ProfileInfoVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 07.05.2021.
//

import UIKit

import Nuke

protocol ProfileInfoDelegate: AnyObject {
    func editProfileAction()
}

/// Экран шапка с информацией о пользователе
final class ProfileInfoVC: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var profileInfoView: UIView!
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var userAgeLabel: UILabel!
    
    // MARK: - Private Properties
    
    weak private var delegate: ProfileInfoDelegate?
    
    // MARK: - Init
    
    init(
        subscriber: ProfileInfoDelegate?
    ) {
        self.delegate = subscriber
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
    
    // MARK: - Public Methods
    
    public func setUserInfo(_ user: UserInformation) {
        let userAge = Date().years(from: user.birthDay)
        userNameLabel.text = "\(user.firstName) \(user.lastName)"
        userAgeLabel.text = "\(userAge) лет"
        
        if let imageURL = user.avatarUrl {
            let options = ImageLoadingOptions(transition: .fadeIn(duration: 0.3))
            Nuke.loadImage(with: imageURL, options: options, into: userImageView)
        }
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        profileInfoView.layer.masksToBounds = true
        profileInfoView.layer.cornerRadius = 24.0
    }
    
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
}
