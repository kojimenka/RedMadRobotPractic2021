//
//  PostsFeedVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 07.05.2021.
//

import UIKit

final class PostsFeedVC: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var zeroScreenContainer: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var zeroScreenTopConstraint: NSLayoutConstraint!
    
    // MARK: - Public Properties
    
    // Эта переменная необходима для отслеживания текущего оффсета коллекции. Мы его отслеживаем что бы менять констрейнт верхнего чайлда с информацией о пользователе
    
    public var scrollViewOffSetChanged: ((CGFloat) -> Void)?
    
    public var showFindFriendsScreen: (() -> Void)?
    
    // MARK: - Private Properties
    
    lazy private var zeroScreen = PostFeedZeroScreenFabric.createZeroScreen(state: screenState)
    
    private let screenState: PostsScreenState
    private var topInset: CGFloat = 0.0
    
    private var requestViewModel: PostsFeedRequestViewModelProtocol
    private var dataSourceViewModel: PostFeedDataSourceViewModelProtocol
    
    // MARK: - Init
    
    init(
        state: PostsScreenState,
        requestViewModel: PostsFeedRequestViewModelProtocol = PostsFeedRequestViewModel(),
        dataSourceViewModel: PostFeedDataSourceViewModelProtocol = PostFeedDataViewModel()
    ) {
        self.screenState = state
        self.requestViewModel = requestViewModel
        self.dataSourceViewModel = dataSourceViewModel
        super.init(
            nibName: R.nib.postsFeedVC.name,
            bundle: R.nib.postsFeedVC.bundle
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupZeroScreen()
    }
    
    // MARK: - Public Methods
    
    // Метод вызывается после установки всех чайлдов в родительском классе, он необходим для установки правильного отступа для коллекции, что бы она не заслоняла чайлд с профилем
    
    public func setTopInset(_ inset: CGFloat) {
        topInset = inset
        collectionView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
    }
    
    // Метод вызывается после того как пользователь вышел с экрана поиска друзей, если пользователь добавил новых друзей мы обновляем данные для отображения
    
    public func updateData() {
        requestData()
    }
    
    // MARK: - Private Methods
    
    private func requestData() {
        requestViewModel.getPosts(screenState: screenState) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.collectionView.isHidden = false
                self.zeroScreenContainer.isHidden = true
                print("DEBUG: post request success")
            case .failure:
                self.collectionView.isHidden = true
                self.zeroScreenContainer.isHidden = false
                print("DEBUG: post request failure")
            }
        }
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = dataSourceViewModel
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.register(
            PostCollectionViewCell.nib(),
            forCellWithReuseIdentifier: PostCollectionViewCell.identifier
        )
    }
    
    private func setupZeroScreen() {
        zeroScreenLayout()
        zeroScreenAction()
        
        if screenState == .feedScreen {
            requestData()
        }
    }
    
    private func zeroScreenLayout() {
        zeroScreenContainer.addFillView(view: zeroScreen)
        
        // Для разных zero экранов нужен разный отступ по высоте
        switch screenState {
        case .feedScreen:
            zeroScreenTopConstraint.constant = view.frame.height * 0.18
        case .userPosts, .userFavoritePosts:
            zeroScreenTopConstraint.constant = view.frame.height * 0.25 + topInset
        }
    }
    
    private func zeroScreenAction() {
        switch screenState {
        case .feedScreen:
            zeroScreen.buttonAction = { [weak self] in
                guard let self = self else { return }
                self.showFindFriendsScreen?()
            }
        case .userPosts, .userFavoritePosts:
            zeroScreen.buttonAction = { [weak self] in
                guard let self = self else { return }
                self.requestData()
            }
        }
    }
    
}

// MARK: - UICollectionView Delegate

extension PostsFeedVC: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath)
    -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: 300)
    }
}

// MARK: - UIScrollView Delegate

extension PostsFeedVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewOffSetChanged?(scrollView.contentOffset.y + topInset)
    }
}
