//
//  PostTableViewCell.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 19.05.2021.
//

import UIKit

final class PostTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var contentStackView: UIStackView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var geolocationStackView: UIStackView!
    @IBOutlet private var cityLabel: UILabel!
    @IBOutlet private var postImageView: UIImageView!
    @IBOutlet private var nickNameLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    
    // MARK: - Public Properties
    
    public var currentPostInfo: PostInfo? {
        didSet {
            guard let currentPostInfo = currentPostInfo else { return }
            fillPostInfo(postInfo: currentPostInfo)
        }
    }
    
    public var likeButtonAction: ((Bool) -> Void)?
    
    // MARK: - UITableViewCell
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupButton()
        setupCell()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margins = UIEdgeInsets(top: 0, left: 16, bottom: 2, right: 16)
        contentView.frame = contentView.frame.inset(by: margins)
    }
    
    // MARK: - IBActions
    
    @IBAction private func addLike(_ sender: Any) {
        likeButton.isSelected.toggle()
        likeButtonAction?(likeButton.isSelected)
    }
    
    // MARK: - Private Methods
    
    private func setupCell() {
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 24
    }
    
    private func setupButton() {
        likeButton.setImage(R.image.unlikePostIcon(), for: .normal)
        likeButton.setImage(R.image.likePostIcon(), for: .selected)
    }
    
    private func fillPostInfo(postInfo: PostInfo) {
        titleLabel.text = postInfo.text
        nickNameLabel.text = "@\(postInfo.author.nickname ?? "")"
                
        geolocationStackView.isHidden = postInfo.lat == nil || postInfo.lon == nil
        postImageView.isHidden = postInfo.imageUrl == nil
        
        likeButton.isSelected = postInfo.isLikedPost
    }
    
}
