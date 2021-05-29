//
//  PostsFeedVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 07.05.2021.
//

import UIKit

protocol PostsFeedDelegate: AnyObject {
    func likePostButtonAction(isLiked: Bool, id: String)
    func getPosts(completion: @escaping (Result<[PostInfo], Error>) -> Void )
}

protocol PostsFeedInProfileDelegate: AnyObject {
    // Эта переменная необходима для отслеживания текущего оффсета коллекции. Мы его отслеживаем что бы менять констрейнт верхнего чайлда с информацией о пользователе
    func scrollViewOffSetChanged(inset: CGFloat)
}

final class PostsFeedVC: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Private Properties
    
    weak private var delegate: PostsFeedDelegate?
    weak private var delegateForProfileScreen: PostsFeedInProfileDelegate?
    
    private var topInset: CGFloat = 0.0
    
    private var dataSourceViewModel: PostFeedDataSourceViewModelProtocol
    
    // MARK: - Init
    
    init(
        profileSubscriber: PostsFeedInProfileDelegate? = nil,
        subscriber: PostsFeedDelegate?,
        dataSourceViewModel: PostFeedDataSourceViewModelProtocol = PostFeedDataViewModel()
    ) {
        delegateForProfileScreen = profileSubscriber
        self.delegate = subscriber
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
        tableView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: - Public Methods
    
    public func requestData() {
        delegate?.getPosts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let content):
                self.dataSourceViewModel.allPosts = content
                DispatchQueue.main.async {
                    self.tableView.reloadData()
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
        delegateForProfileScreen?.scrollViewOffSetChanged(inset: scrollView.contentOffset.y + topInset)
    }
    
}

// MARK: - DataSource Delegate

extension PostsFeedVC: PostFeedDataViewModelDelegate {
    
    func likePostButtonAction(isLiked: Bool, id: String) {
        delegate?.likePostButtonAction(isLiked: isLiked, id: id)
    }
    
}
