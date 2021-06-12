//
//  AllFriendsListDataSource.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 09.06.2021.
//

import UIKit

protocol AllFriendsListDataSource: UITableViewDataSource {
    var allFriends: [UserInformation] { get set }
    var allFriendsDeleted: (() -> Void)? { get set }
    var deleteFriend: ((String) -> Void)? { get set }
}

final class AllFriendsListDataSourceImpl: NSObject, AllFriendsListDataSource {
    
    // MARK: - Public Properties
    
    public var allFriends = [UserInformation]()

    public var allFriendsDeleted: (() -> Void)?
    public var deleteFriend: ((String) -> Void)?
}

// MARK: - UITableViewDataSource

extension AllFriendsListDataSourceImpl {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allFriends.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FriendTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.currentUser = allFriends[indexPath.section]
        
        cell.deleteFriend = { [weak self] in
            guard let self = self,
                  let actualIndexPath = tableView.indexPath(for: cell)
            else { return }
            
            self.deleteFriend?(self.allFriends[actualIndexPath.section].id)
            self.allFriends.remove(at: actualIndexPath.section)
            tableView.deleteSections(IndexSet(integer: actualIndexPath.section), with: .left)
            
            if self.allFriends.isEmpty {
                self.allFriendsDeleted?()
            }
        }
        
        return cell
    }
    
}
