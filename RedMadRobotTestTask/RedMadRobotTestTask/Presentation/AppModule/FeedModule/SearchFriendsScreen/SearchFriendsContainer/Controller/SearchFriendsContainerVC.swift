//
//  SearchFriendsContainerVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 16.05.2021.
//

import UIKit

final class SearchFriendsContainerVC: UIViewController {
    
    // MARK: - IBOulets

    @IBOutlet private weak var contentView: UIView!
    
    // MARK: - Private Properties
    
    private weak var coordinator: FeedModuleCoordinator?
    private var requestViewModel: SearchFriendsRequestViewModel
    
    lazy private var friendsListVC = FoundedFriendsListVC(subscriber: self)
    lazy private var searchScreen = SearchFriendsVC(subscriber: self, friendsListVC: friendsListVC)
    
    // MARK: - Init
    
    init(
        coordinator: FeedModuleCoordinator?,
        requestViewModel: SearchFriendsRequestViewModel = SearchFriendsRequestViewModelImpl()
    ) {
        self.requestViewModel = requestViewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            coordinator?.backToFeedScreen()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupChilds()
        getUserFriends()
        navBarSetup()
    }
    
    // MARK: - Private Methods
    
    private func navBarSetup() {
        title = "Найти друзей"
    }

    private func setupChilds() {
        addChild(controller: searchScreen, rootView: contentView)
    }
    
    private func getUserFriends() {
        requestViewModel.getUserFriends { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let users):
                self.friendsListVC.setUserFriends(users: users)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

// MARK: - Search Friend

extension SearchFriendsContainerVC: FoundedFriendsListDelegate {
    
    func addNewFriend(id: String) {
        requestViewModel.addNewFriend(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.getUserFriends()
            case .failure:
                break
            }
        }
    }
    
}

extension SearchFriendsContainerVC: SearchFriendsDelegate {
    
    func searchFriend(name: String) {
        requestViewModel.searchFriends(name: name) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let users):
                self.friendsListVC.setNewFriends(users: users, isTextEmpty: name.isEmpty)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
