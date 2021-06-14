//
//  FoundedFriendsListCell.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 16.05.2021.
//

import UIKit

import Nuke

final class FoundedFriendsListCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var nickNameLabel: UILabel!
    @IBOutlet private weak var addButton: UIButton!
    
    // MARK: - Public Properties
    
    public var addFriend: ((String) -> Void)?
    
    public var currentUser: UserInformation? {
        didSet {
            guard let currentUser = currentUser else { return }
            setupView(user: currentUser)
        }
    }
    
    public var isAlreadyFriend: Bool? {
        didSet {
            guard let isAlreadyFriend = isAlreadyFriend else { return }
            addButton.isHidden = isAlreadyFriend
        }
    }
    
    // MARK: - UICollectionView Cell
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - IBActions
    
    @IBAction private func addButtonAction(_ sender: Any) {
        if let id = currentUser?.id {
            addFriend?(id)
        }
    }
    
    // MARK: - Private Methods
    
    private func setupView(user: UserInformation) {
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        nickNameLabel.text = "@\(user.nickname ?? "")"
        
        if let imageURL = user.avatarUrl {
            let options = ImageLoadingOptions(
                placeholder: R.image.emptyUserPhoto(),
                transition: .fadeIn(duration: 0.3),
                failureImage: R.image.emptyUserPhoto()
            )
            Nuke.loadImage(with: imageURL, options: options, into: userImageView)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userImageView.image = R.image.emptyUserPhoto()
    }
    
}
