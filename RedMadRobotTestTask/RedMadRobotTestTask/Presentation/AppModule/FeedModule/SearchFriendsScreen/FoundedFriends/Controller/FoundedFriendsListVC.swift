//
//  FoundedFriendsListVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 16.05.2021.
//

import UIKit

protocol FoundedFriendsListDelegate: AnyObject {
    func addNewFriend(id: String)
}

/// Экран для отображения найденых друзей
final class FoundedFriendsListVC: UIViewController {
    
    // MARK: - IBOutlets

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var warningLabel: UILabel!
    
    // MARK: - Private Properties
    
    weak private var delegate: FoundedFriendsListDelegate?
    private var dataSource: FoundedFriendDataSource
    
    // MARK: - Init
    
    init(
        subscriber: FoundedFriendsListDelegate?,
        dataSource: FoundedFriendDataSource = FoundedFriendDataSourceImpl()
    ) {
        self.delegate = subscriber
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
        self.dataSource.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Public Methods
    
    /// Устанавливаем список новых друзей
    /// - Parameters:
    ///   - users: список друзей для отображения
    ///   - isTextEmpty: введен ли текст в SearchBar
    public func setNewFriends(users: [UserInformation], isTextEmpty: Bool) {
        
        if !users.isEmpty && isTextEmpty {
            warningLabel.text = "Начните вводить имя\nили никнейм вашего друга"
            warningLabel.animateShow()
            collectionView.animateHide()
        } else if !users.isEmpty {
            warningLabel.animateHide()
            collectionView.animateShow()
        } else {
            warningLabel.text = "Пользователи не найдены"
            warningLabel.animateShow()
            collectionView.animateHide()
        }
        
        dataSource.allFoundedUsers = users
        collectionView.reloadSections(IndexSet(integer: 0))
    }
    
    /// Метод для первого отображения пользователей, происходит без анимации
    /// - Parameter users: список друзей для отображения
    public func setUserFriends(users: [UserInformation]) {
        dataSource.userFriends = users
        collectionView.reloadSections(IndexSet(integer: 0))
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        collectionView.dataSource = dataSource
        collectionView.register(
            FoundedFriendsListCell.nib(),
            forCellWithReuseIdentifier: FoundedFriendsListCell.identifier
        )
    }
    
}

// MARK: - DataSource Delegate

extension FoundedFriendsListVC: FoundedFriendDataSourceDelegate {
    
    func addNewFriend(id: String) {
        delegate?.addNewFriend(id: id)
    }
    
}

// MARK: - UICollectionView Delegate

extension FoundedFriendsListVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath)
    -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 67)
    }
    
}
