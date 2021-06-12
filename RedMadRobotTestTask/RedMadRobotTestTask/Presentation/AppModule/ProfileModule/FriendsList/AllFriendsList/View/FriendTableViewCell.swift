//
//  FriendTableViewCell.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 09.06.2021.
//

import UIKit

final class FriendTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var userPhotoImageView: UIImageView!
    @IBOutlet private weak var deleteFriendButton: UIButton!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var nickNameLabel: UILabel!
    
    // MARK: - Public Properties
    
    public var currentUser: UserInformation? {
        didSet {
            guard let currentUser = currentUser else { return }
            nameLabel.text = "\(currentUser.firstName) \(currentUser.lastName)"
            nickNameLabel.text = "@\(currentUser.nickname ?? "")"
        }
    }
    
    public var deleteFriend: (() -> Void)?
    
    // MARK: - UITableViewCell

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .white
        initialSetup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margins = UIEdgeInsets(top: 0, left: 16, bottom: 4, right: 16)
        contentView.frame = contentView.frame.inset(by: margins)
    }
    
    // MARK: - IBActions
    
    @IBAction private func deleteFriendAction(_ sender: Any) {
        deleteFriend?()
    }
    
    // MARK: - Private Methods
    
    private func initialSetup() {
        setupCell()
        setupSelectedView()
    }
    
    private func setupCell() {
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 24
    }
    
    private func setupSelectedView() {
        let selectedView = UIView()
        selectedView.backgroundColor = .clear
        self.selectedBackgroundView = selectedView
    }
    
}
