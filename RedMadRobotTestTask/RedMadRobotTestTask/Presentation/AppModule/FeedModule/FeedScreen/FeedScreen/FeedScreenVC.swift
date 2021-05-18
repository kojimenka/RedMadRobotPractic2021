//
//  FeedScreenContainerVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

protocol FeedScreeDelegate: class {

}

final class FeedScreenVC: UIViewController {
    
    // MARK: - IBOutlets

    @IBOutlet private weak var feedContainerView: UIView!
    
    // MARK: - Private Properties

    weak private var delegate: FeedScreeDelegate?
    weak private var allPostsVC: PostsFeedVC?
    
    // MARK: - Initializers
    
    init(
        subscriber: FeedScreeDelegate?,
        allPostsVC: PostsFeedVC?
    ) {
        self.delegate = subscriber
        self.allPostsVC = allPostsVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setChilds()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        view.backgroundColor = ColorPalette.mainBackgroundColor
    }
    
    private func setChilds() {
        guard let allPostsVC = allPostsVC else { return }
        addChild(controller: allPostsVC, rootView: feedContainerView)
    }

}
