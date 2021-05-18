//
//  FoundedFriendDataSource.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 16.05.2021.
//

import UIKit

protocol FoundedFriendDataSourceDelegate: AnyObject {
    func addNewFriend(id: String)
}

protocol FoundedFriendDataSource: UICollectionViewDataSource {
    var allFoundedUsers: [UserInformation] { get set }
    var userFriends: [UserInformation] { get set }
    var delegate: FoundedFriendDataSourceDelegate? { get set }
}

final class FoundedFriendDataSourceImpl: NSObject, FoundedFriendDataSource {
    
    // MARK: - Public properties

    public var allFoundedUsers = [UserInformation]()
    public var userFriends = [UserInformation]()
    
    weak public var delegate: FoundedFriendDataSourceDelegate?
    
}

// MARK: - UICollectionView DataSource

extension FoundedFriendDataSourceImpl: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allFoundedUsers.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: FoundedFriendsListCell = collectionView.dequeueCell(for: indexPath)
        let currentUser = allFoundedUsers[indexPath.row]
        cell.currentUser = currentUser
        cell.isAlreadyFriend = userFriends.contains(currentUser)
        
        cell.addFriend = { [weak self] userID in
            guard let self = self else { return }
            self.delegate?.addNewFriend(id: userID)
        }
        
        return cell
    }
    
}
