//
//  PostFeedDataViewModel.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 11.05.2021.
//

import UIKit

protocol PostFeedDataSourceViewModelProtocol: AnyObject, UICollectionViewDataSource {
    var allPosts: [PostInfo] { get set }
    var delegate: PostFeedDataViewModelDelegate? { get set }
}

protocol PostFeedDataViewModelDelegate: AnyObject {
    func likePost(id: String)
}

final class PostFeedDataViewModel: NSObject, PostFeedDataSourceViewModelProtocol {
    
    // MARK: - Public Properties
    
    public var allPosts = [PostInfo]()
    public weak var delegate: PostFeedDataViewModelDelegate?
}

// MARK: - UICollectionView DataSource

extension PostFeedDataViewModel: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PostCollectionViewCell.identifier,
            for: indexPath
        ) as! PostCollectionViewCell
        
        let currentPost = allPosts[indexPath.row]
        
        cell.currentPostInfo = currentPost
        
        cell.likeButtonAction = { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.likePost(id: currentPost.id)
        }
        
        return cell
    }

}
