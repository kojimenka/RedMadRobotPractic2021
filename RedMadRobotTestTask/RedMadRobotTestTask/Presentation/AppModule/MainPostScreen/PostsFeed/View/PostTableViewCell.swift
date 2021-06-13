//
//  PostTableViewCell.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 19.05.2021.
//

import UIKit

import Nuke

import MapKit

final class PostTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var contentStackView: UIStackView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var geolocationStackView: UIStackView!
    @IBOutlet private var cityLabel: UILabel!
    @IBOutlet private var postImageView: UIImageView!
    @IBOutlet private var nickNameLabel: UILabel!
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Public Properties
    
    public var currentPostInfo: PostInfo? {
        didSet {
            guard let currentPostInfo = currentPostInfo else { return }
            fillPostInfo(postInfo: currentPostInfo)
        }
    }
    
    public var isFavoritePost: Bool? {
        didSet {
            guard let isFavoritePost = isFavoritePost else { return }
            likeButton.isSelected = isFavoritePost
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
        
        downloadImage(imageUrl: postInfo.imageUrl)
        
        setGeoPosition(postInfo: postInfo)
    }
    
    private func downloadImage(imageUrl: URL?) {
        activityIndicator.startAnimating()
        if let imageURL = imageUrl {
            
            let options = ImageLoadingOptions(
                transition: .fadeIn(duration: 0.3)
            )
            
            Nuke.loadImage(
                with: imageURL,
                options: options,
                into: postImageView
            ) { [weak self] _ in
                guard let self = self else { return }
                self.activityIndicator.animateHide()
            }
        }
    }
    
    private func setGeoPosition(postInfo: PostInfo) {
        let currentLocation = CLLocation(
            latitude: Double(postInfo.lat ?? 0.0),
            longitude: Double(postInfo.lon ?? 0.0)
        )
        
        currentLocation.fetchCityAndCountry { [weak self] city, country, error in
            guard let self = self,
                  let city = city,
                  let country = country,
                  error == nil else {
                return
            }
            
            let addressText = "\(country), \(city)"
            DispatchQueue.main.async {
                self.cityLabel.text = addressText
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
        activityIndicator.alpha = 1.0
        activityIndicator.isHidden = false
        likeButton.isSelected = false
    }
}
