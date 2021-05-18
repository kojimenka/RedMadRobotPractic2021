//
//  PostCollectionViewCell.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 07.05.2021.
//

import UIKit

final class PostCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var postTextLabel: UILabel!
    @IBOutlet private weak var geopositionLabel: UILabel!
    @IBOutlet private weak var geopositionStackView: UIStackView!
    @IBOutlet private weak var contentImageView: UIImageView!
    @IBOutlet private weak var nickNameLabel: UILabel!
    
    // MARK: - Public Properties
    
    public var currentPostInfo: PostInfo? {
        didSet {
            guard let currentPostInfo = currentPostInfo else { return }
            fillPostInfo(postInfo: currentPostInfo)
        }
    }
    
    public var likeButtonAction: ((Bool) -> Void)?
    
    // MARK: - UICollectionView Cell
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    // MARK: - IBActions
    
    @IBAction private func likeButtonAction(_ sender: Any) {
        likeButtonAction?(true)
    }
    
    // MARK: - Private Methods
    
    private func setupCell() {
        contentView.backgroundColor = .white
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 24
    }
    
    private func fillPostInfo(postInfo: PostInfo) {
        postTextLabel.text = postInfo.text
        nickNameLabel.text = "@\(postInfo.author.nickname ?? "")"
        
        contentImageView.isHidden = postInfo.imageUrl == nil
        if postInfo.lat == nil && postInfo.lon == nil {
            if geopositionStackView != nil {
                geopositionStackView.removeFromSuperview()
            }
        }
    }
    
}
