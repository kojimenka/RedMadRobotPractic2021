//
//  PostFeedDataViewModel.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 11.05.2021.
//

import UIKit

protocol PostFeedDataSourceViewModelProtocol: AnyObject, UICollectionViewDataSource {
    // В будущем здесь будет массив с данным для коллекции
    // var allData: [?] { get }
}

final class PostFeedDataViewModel: NSObject, PostFeedDataSourceViewModelProtocol {
    
}

// MARK: - UICollectionView DataSource

extension PostFeedDataViewModel: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PostCollectionViewCell.identifier,
            for: indexPath
        ) as! PostCollectionViewCell
        
        cell.backgroundColor = .white
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 24
        
        return cell
    }

}
