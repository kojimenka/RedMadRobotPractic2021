//
//  FeedScreenVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

final class FeedScreenVC: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FeedScreenCell.nib(), forCellWithReuseIdentifier: FeedScreenCell.identifier)
    }

}

// MARK: - Zero Screen Delegate

extension FeedScreenVC: ZeroScreenViewDelegate {
    func updateButtonAction() {
        print("Update")
    }
}

// MARK: - UICollectionView DataSource

extension FeedScreenVC: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int)
    -> Int {
        return 3
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        
        let cell: FeedScreenCell = collectionView.dequeueCell(for: indexPath)
        cell.backgroundColor = .red
        
        return cell
    }
}

// MARK: - UICollectionView Delegate

extension FeedScreenVC: UICollectionViewDelegateFlowLayout {
    
}
