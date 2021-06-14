//
//  PostsFeedVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 07.05.2021.
//

import UIKit

protocol PostsFeedDelegate: AnyObject {
    func getPosts(completion: @escaping (Result<[PostInfo], Error>) -> Void )
    func scrollViewOffSetChanged(inset: CGFloat)
}

/// Основной экран для отображение постов, переиспользуется 3 раза: новостная лента, посты пользователя и все посты с лайками.
final class PostsFeedVC: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Private Properties
    
    weak private var delegate: PostsFeedDelegate?
    
    private let feedService: FeedService
    
    private var dataSourceViewModel: PostFeedDataSourceViewModelProtocol
    
    /// Менеджер который содержит текущие любимые посты
    private let favouritePostsManager: FavouritePostsManager
    
    /// Менеджер хранящий данные каким экраном нужно обновить данные
    private var updateManager: UpdateManager
    
    /// Отступ равный высоте шапки с профилем
    private var topInset: CGFloat = 0.0
    
    /// Возможность удаления постов есть только на экране с поставим пользователе
    private var isUserCanDeletePost = false
    private var isFirstLayout = true
    
    // MARK: - Init
    
    init(
        subscriber: PostsFeedDelegate?,
        favouritePostsManager: FavouritePostsManager = ServiceLayer.shared.favouritePostsManager,
        dataSourceViewModel: PostFeedDataSourceViewModelProtocol = PostFeedDataViewModel(),
        updateManager: UpdateManager = ServiceLayer.shared.updateManager,
        feedService: FeedService = ServiceLayer.shared.feedService
    ) {
        self.delegate = subscriber
        self.favouritePostsManager = favouritePostsManager
        self.updateManager = updateManager
        self.dataSourceViewModel = dataSourceViewModel
        self.feedService = feedService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    /// Незаметно для пользователе ставим отступ для таблицы с размеров в шапку пользователя
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard isFirstLayout == true else { return }
        tableView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        tableView.setContentOffset(CGPoint(x: 0, y: -topInset - navBarHeight), animated: false)
        isFirstLayout = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    // MARK: - Public Methods
    
    /// Метод вызывается после установки всех чайлдов в родительском классе, он необходим для установки правильного отступа для коллекции, что бы она не заслоняла чайлд с профилем
    public func setTopInset(_ inset: CGFloat) {
        topInset = inset
    }
    
    /// Вызывается экраном с постами пользователя для разрешения удаления постов
    public func activateDeleteAction() {
        isUserCanDeletePost = true
    }
    
    /// Так как данные для отображения всегда разные, контейнер который хранит этот экран, сам дает необходимые данные
    public func requestData() {
        delegate?.getPosts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let content):
                self.dataSourceViewModel.allPosts = content
                DispatchQueue.main.async {
                    if let tableView = self.tableView {
                        tableView.reloadData()
                    }
                }
            case .failure:
                print("DEBUG: post request failure")
            }
        }
    }
    
    public func reloadTableView() {
        if let tableView = tableView {
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
    }
    
    private func setupTableView() {
        dataSourceViewModel.delegate = self
        tableView.dataSource = dataSourceViewModel
        tableView.estimatedRowHeight = 305
        tableView.rowHeight = UITableView.automaticDimension

        tableView.register(
            PostTableViewCell.nib(),
            forCellReuseIdentifier: PostTableViewCell.identifier
        )
    }
    
    // MARK: - Private Properties
    
    private func deletePost(id: String) {
        _ = feedService.deletePost(postID: id) { [weak self] res in
            guard let self = self else { return }
            switch res {
            case .success:
                self.updateManager.isUpdateFeedNeeded = true
            case .failure:
                break
            }
        }
    }
    
}

// MARK: - UITableView Delegate

extension PostsFeedVC: UITableViewDelegate {
    
    /// Метод для возможности удаления ячеек с помощью свайпа
     func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
     -> UISwipeActionsConfiguration? {
        
        guard isUserCanDeletePost == true else { return nil }

        let delete = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, _ in
            guard let self = self else { return }
            self.deletePost(id: self.dataSourceViewModel.allPosts[indexPath.section].id)
            self.dataSourceViewModel.allPosts.remove(at: indexPath.section)
            self.tableView.deleteSections(IndexSet(integer: indexPath.section), with: .left)
        }

        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = true
        
        return swipeActionConfig
    }
    
}

// MARK: - UIScrollView Delegate

extension PostsFeedVC: UIScrollViewDelegate {
    
    /// Передаем контейнеру текущий оффсет, для изменения положения шапки пользователя
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewOffSetChanged(inset: scrollView.contentOffset.y + topInset)
    }
    
}

// MARK: - DataSource Delegate

extension PostsFeedVC: PostFeedDataViewModelDelegate {
    
    func likePostButtonAction(isLiked: Bool, post: PostInfo) {
        if isLiked {
            likePost(post: post)
        } else {
            unlikePost(id: post.id)
        }
    }
    
    func likePost(post: PostInfo) {
        favouritePostsManager.addLikedPost(post: post)
    }
    
    func unlikePost(id: String) {
        favouritePostsManager.removeLikeFromPost(id: id)
    }
    
}
