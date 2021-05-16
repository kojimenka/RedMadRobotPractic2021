//
//  SearchFriendsVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 08.05.2021.
//

import UIKit

protocol SearchFriendsOutputDelegate: class {
    func backToFeedScreen()
}

final class SearchFriendsVC: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var contentView: UIView!
    
    // MARK: - Private Properties
    
    weak private var outputDelegate: SearchFriendsOutputDelegate?
    
    // MARK: - Init
    
    init(outputSubscriber: SearchFriendsOutputDelegate?) {
        self.outputDelegate = outputSubscriber
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: - UIViewController
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            outputDelegate?.backToFeedScreen()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Private Methods
    
}
