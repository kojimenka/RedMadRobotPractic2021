//
//  PostTableViewCell.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 19.05.2021.
//

import UIKit

class PostImageView: UIImageView {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 148, height: 100)
    }
}

final class PostTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var contentStackView: UIStackView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var geolocationStackView: UIStackView!
    @IBOutlet private var cityLabel: UILabel!
    @IBOutlet private var postImageView: PostImageView!
    @IBOutlet private var nickNameLabel: UILabel!
    @IBOutlet private var likeButton: UIButton!
    
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
        setupSelectedView()
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
        titleLabel.sizeToFit()
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 24
    }
    
    private func setupButton() {
        likeButton.setImage(R.image.unlikePostIcon(), for: .normal)
        likeButton.setImage(R.image.likeButton(), for: .selected)
    }
    
    private func setupSelectedView() {
        let selectedView = UIView()
        selectedView.backgroundColor = .clear
        self.selectedBackgroundView = selectedView
    }
    
    private func fillPostInfo(postInfo: PostInfo) {
        titleLabel.text = postInfo.text
        nickNameLabel.text = "@\(postInfo.author.nickname ?? "")"

        geolocationStackView.isHidden = postInfo.lat == nil || postInfo.lon == nil
        postImageView.isHidden = postInfo.imageUrl == nil
        
        likeButton.isSelected = postInfo.isLikedPost
    }
    
}
