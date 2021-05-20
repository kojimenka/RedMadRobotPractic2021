//
//  PostTableViewCell.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 19.05.2021.
//

import UIKit

final class PostTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private var geolocationStackView: UIStackView!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private var postImageView: UIImageView!
    @IBOutlet private weak var nickNameLabel: UILabel!
    
    // MARK: - Public Properties
    
    public var currentPostInfo: PostInfo? {
        didSet {
            guard let currentPostInfo = currentPostInfo else { return }
            fillPostInfo(postInfo: currentPostInfo)
        }
    }
    
    public var likeButtonAction: ((Bool) -> Void)?
    
    // MARK: - Private Properties
    
    private var geolocationStackViewConstraints = [NSLayoutConstraint]()
    private var postImageViewConstraints = [NSLayoutConstraint]()
    
    // MARK: - UITableViewCell
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margins = UIEdgeInsets(top: 0, left: 16, bottom: 2, right: 16)
        contentView.frame = contentView.frame.inset(by: margins)
    }
    
    // MARK: - IBActions
    
    @IBAction private func addLike(_ sender: Any) {
        likeButtonAction?(true)
    }
    
    // MARK: - Private Methods
    
    private func setupCell() {
        contentView.backgroundColor = .white
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 24
    }
    
    private func fillPostInfo(postInfo: PostInfo) {
        titleLabel.text = postInfo.text
        nickNameLabel.text = "@\(postInfo.author.nickname ?? "")"
        
        // Для отображения нужных приоритетов для констрейнтов, нужно убирать со view не использующиеся View. Так как при removeFromSuperview так же уходят и констрейнты, я их сохраняю и заново активирую в PrepareForReuse, надеюсь подход правильный
    
        if postInfo.lat == nil && postInfo.lon == nil {
            if geolocationStackView != nil {
                geolocationStackViewConstraints = contentView.getConstraintsOf(geolocationStackView)
                geolocationStackView.removeFromSuperview()
            }
        }
        
        if postInfo.imageUrl == nil {
            if postImageView != nil {
                postImageViewConstraints = contentView.getConstraintsOf(postImageView)
                postImageView.removeFromSuperview()
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.addSubview(geolocationStackView)
        contentView.addSubview(postImageView)
        
        geolocationStackViewConstraints.forEach({ $0.isActive = true })
        postImageViewConstraints.forEach({ $0.isActive = true })
    }
    
}
