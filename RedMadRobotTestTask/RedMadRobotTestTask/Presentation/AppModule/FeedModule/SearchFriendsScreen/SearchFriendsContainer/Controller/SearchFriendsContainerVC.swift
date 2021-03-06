//
//  SearchFriendsContainerVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 16.05.2021.
//

import UIKit

/// Контейнер для экрана поиска друзей.
final class SearchFriendsContainerVC: UIViewController {
    
    // MARK: - IBOulets

    @IBOutlet private weak var contentView: UIView!
    
    // MARK: - Private Properties
    
    /// ViewModel для совершения запросов
    private var requestViewModel: SearchFriendsRequestViewModel
    
    /// Экран для отображения списка друзей
    lazy private var friendsListVC = FoundedFriendsListVC(subscriber: self)
    
    /// Экран который объединяет в UI SerchBar и экран с отображением друзей
    lazy private var searchScreen = SearchFriendsVC(subscriber: self, friendsListVC: friendsListVC)
    
    /// Менеджер хранящий данные, каким экраном нужно обновить данные
    private var updateManager: UpdateManager
    
    // MARK: - Init
    
    init(
        updateManager: UpdateManager = ServiceLayer.shared.updateManager,
        requestViewModel: SearchFriendsRequestViewModel = SearchFriendsRequestViewModelImpl()
    ) {
        self.updateManager = updateManager
        self.requestViewModel = requestViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
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
            case .failure:
                break
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
                self.updateManager.isUpdateFeedNeeded = true
                self.updateManager.isUpdateFriendsNeeded = true
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
