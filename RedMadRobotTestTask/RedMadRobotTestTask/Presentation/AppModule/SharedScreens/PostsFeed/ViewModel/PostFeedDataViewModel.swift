//
//  PostFeedDataViewModel.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 11.05.2021.
//

import UIKit

protocol PostFeedDataSourceViewModelProtocol: AnyObject, UITableViewDataSource {
    var allPosts: [PostInfo] { get set }
    var delegate: PostFeedDataViewModelDelegate? { get set }
}

protocol PostFeedDataViewModelDelegate: AnyObject {
    func likePostButtonAction(isLiked: Bool, id: String)
}

final class PostFeedDataViewModel: NSObject, PostFeedDataSourceViewModelProtocol {
    
    // MARK: - Public Properties
    
    public var allPosts = [PostInfo]()
    public weak var delegate: PostFeedDataViewModelDelegate?
}

// MARK: - UICollectionView DataSource

extension PostFeedDataViewModel: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allPosts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
    -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        let cell: PostTableViewCell = tableView.dequeueCell(for: indexPath)
        let currentPost = allPosts[indexPath.section]
        
        cell.currentPostInfo = currentPost

        cell.likeButtonAction = { [weak self] isLiked in
            guard let self = self else { return }
            self.allPosts[indexPath.section].isLikedPost = isLiked
            self.delegate?.likePostButtonAction(isLiked: isLiked, id: currentPost.id)
        }
        
        return cell
    }
}
