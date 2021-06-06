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

final class PostsFeedVC: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Private Properties
    
    weak private var delegate: PostsFeedDelegate?
    private let feedService: FeedServiceProtocol
    
    private var topInset: CGFloat = 0.0
    private var isFirstStart = true
    
    private var dataSourceViewModel: PostFeedDataSourceViewModelProtocol
    
    // MARK: - Init
    
    init(
        subscriber: PostsFeedDelegate?,
        feedService: FeedServiceProtocol = ServiceLayer.shared.feedService,
        dataSourceViewModel: PostFeedDataSourceViewModelProtocol = PostFeedDataViewModel()
    ) {
        self.delegate = subscriber
        self.feedService = feedService
        self.dataSourceViewModel = dataSourceViewModel
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard isFirstStart == true else { return }
        tableView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        tableView.setContentOffset(CGPoint(x: 0, y: -topInset - navBarHeight), animated: false)
        isFirstStart = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    // MARK: - Public Methods
    
    // Метод вызывается после установки всех чайлдов в родительском классе, он необходим для установки правильного отступа для коллекции, что бы она не заслоняла чайлд с профилем
    
    public func setTopInset(_ inset: CGFloat) {
        topInset = inset
    }
    
    // MARK: - Public Methods
    
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
    
    private func setupCollectionView() {
        dataSourceViewModel.delegate = self
        tableView.dataSource = dataSourceViewModel
        tableView.estimatedRowHeight = 305
        tableView.rowHeight = UITableView.automaticDimension

        tableView.register(
            PostTableViewCell.nib(),
            forCellReuseIdentifier: PostTableViewCell.identifier
        )
    }    
    
}

// MARK: - UITableView Delegate

extension PostsFeedVC: UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - UIScrollView Delegate

extension PostsFeedVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewOffSetChanged(inset: scrollView.contentOffset.y + topInset)
    }
    
}

// MARK: - DataSource Delegate

extension PostsFeedVC: PostFeedDataViewModelDelegate {
    
    func likePostButtonAction(isLiked: Bool, id: String) {
        if isLiked {
            likePost(id: id)
        } else {
            unlikePost(id: id)
        }
    }
    
    func likePost(id: String) {
        _ = feedService.addLikeToPost(postID: id) { result in
            switch result {
            case .success:
                print("DEBUG: Success add like")
            case .failure(let error):
                print("DEBUG: Failure add like with error  \(error.localizedDescription)")
            }
        }
    }
    
    func unlikePost(id: String) {
        _ = feedService.removeLikeFromPost(postID: id) { result in
            switch result {
            case .success:
                print("DEBUG: Success remove like")
            case .failure(let error):
                print("DEBUG: Failure remove like with error  \(error.localizedDescription)")
            }
        }
    }
    
}
