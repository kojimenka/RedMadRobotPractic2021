//
//  SearchFriendsVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 08.05.2021.
//

import UIKit

protocol SearchFriendsDelegate: AnyObject {
    func searchFriend(name: String)
}

/// Экран объединяющий SearchBar и чайлд с отображением друзей
final class SearchFriendsVC: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var contentView: UIView!
    
    // MARK: - Private Properties
    
    weak private var delegate: SearchFriendsDelegate?
    weak private var friendsListVC: FoundedFriendsListVC?
    
    // MARK: - Init
    
    init(
        subscriber: SearchFriendsDelegate?,
        friendsListVC: FoundedFriendsListVC?
    ) {
        self.delegate = subscriber
        self.friendsListVC = friendsListVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupChilds()
    }
    
    // MARK: - Private Methods
    
    private func setupChilds() {
        guard let friendsListVC = friendsListVC else { return }
        addChild(controller: friendsListVC, rootView: contentView)
    }
    
    private func setupViews() {
        searchBar.delegate = self
    }
    
}

// MARK: - Search Bar Delegate

extension SearchFriendsVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.searchFriend(name: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
