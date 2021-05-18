//
//  PostsFeedVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 07.05.2021.
//

import UIKit

protocol PostsFeedDelegate: AnyObject {
    func failureRequest()
    func likePost(id: String)
    func emptyPosts()
}

protocol PostsFeedInProfileDelegate: AnyObject {
    // Эта переменная необходима для отслеживания текущего оффсета коллекции. Мы его отслеживаем что бы менять констрейнт верхнего чайлда с информацией о пользователе
    func scrollViewOffSetChanged(inset: CGFloat)
}

final class PostsFeedVC: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Private Properties
    
    weak private var delegate: PostsFeedDelegate?
    weak private var delegateForProfileScreen: PostsFeedInProfileDelegate?
    
    private var topInset: CGFloat = 0.0
    
    private var requestViewModel: PostsFeedRequestViewModelProtocol
    private var dataSourceViewModel: PostFeedDataSourceViewModelProtocol
    
    // MARK: - Init
    
    init(
        profileSubscriber: PostsFeedInProfileDelegate? = nil,
        subscriber: PostsFeedDelegate?,
        requestViewModel: PostsFeedRequestViewModelProtocol,
        dataSourceViewModel: PostFeedDataSourceViewModelProtocol = PostFeedDataViewModel()
    ) {
        delegateForProfileScreen = profileSubscriber
        self.delegate = subscriber
        self.requestViewModel = requestViewModel
        self.dataSourceViewModel = dataSourceViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    // MARK: - Public Methods
    
    // Метод вызывается после установки всех чайлдов в родительском классе, он необходим для установки правильного отступа для коллекции, что бы она не заслоняла чайлд с профилем
    
    public func setTopInset(_ inset: CGFloat) {
        topInset = inset
        collectionView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: - Public Methods
    
    public func requestData(completion: ((Bool) -> Void)? = nil) {
        requestViewModel.getPosts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let content):
                print("DEBUG: post request success")
                if content.isEmpty {
                    self.delegate?.emptyPosts()
                    completion?(false)
                }
                completion?(true)
                self.dataSourceViewModel.allPosts = content
                self.collectionView.reloadSections(IndexSet(integer: 0))
            case .failure:
                completion?(false)
                self.delegate?.failureRequest()
                print("DEBUG: post request failure")
            }
        }
    }
    
    private func setupCollectionView() {
        dataSourceViewModel.delegate = self
        collectionView.dataSource = dataSourceViewModel
        collectionView.contentInsetAdjustmentBehavior = .never

        collectionView.register(
            PostCollectionViewCell.nib(),
            forCellWithReuseIdentifier: PostCollectionViewCell.identifier
        )
    }
    
}

// MARK: - UICollectionView Delegate

extension PostsFeedVC: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath)
    -> CGSize {
        let width = collectionView.frame.width - 32
        let currentPost = dataSourceViewModel.allPosts[indexPath.row]
        let inset: CGFloat = 16.0
        
        let titleText = currentPost.text ?? ""
        guard let titleFont = R.font.ibmPlexSans(size: 28) else { return CGSize(width: 0, height: 0) }
        
        let textSize = CGSize(width: width - 32, height: 1000)
        let textAttributes = [NSAttributedString.Key.font: titleFont]
        
        let titleTextHeight = NSString(string: titleText).boundingRect(
            with: textSize,
            options: .usesLineFragmentOrigin,
            attributes: textAttributes,
            context: nil
        ).height
        
        var geopositionHeight: CGFloat = 0.0
        var imageHeight: CGFloat = 0.0
        let authorHeight: CGFloat = 35.5
        
        if currentPost.lon != nil && currentPost.lat != nil {
            geopositionHeight = inset + 17
        }
        
        if currentPost.imageUrl != nil {
            let imageWidth = width * 0.4
            imageHeight = inset + imageWidth * 0.67
        }
        
        let height: CGFloat = inset + titleTextHeight + geopositionHeight + imageHeight + authorHeight + inset
        
        return CGSize(width: width, height: height)
    }
}

// MARK: - UIScrollView Delegate

extension PostsFeedVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegateForProfileScreen?.scrollViewOffSetChanged(inset: scrollView.contentOffset.y + topInset)
    }
}

// MARK: - DataSource Delegate

extension PostsFeedVC: PostFeedDataViewModelDelegate {
    func likePost(id: String) {
        delegate?.likePost(id: id)
    }
}
