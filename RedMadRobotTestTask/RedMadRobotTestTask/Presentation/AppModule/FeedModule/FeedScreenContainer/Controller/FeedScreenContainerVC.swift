//
//  FeedScreenContainerVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

protocol FeedScreenOutPutDelegate: class {
    func showSearchFriendScreen()
}

final class FeedScreenContainerVC: UIViewController {
    
    // MARK: - IBOutlets

    @IBOutlet private weak var feedContainerView: UIView!
    
    // MARK: - Private Properties

    weak private var outputDelegate: FeedScreenOutPutDelegate?
    
    lazy private var allPostsVC = PostsFeedVC(
        subscriber: self,
        requestViewModel: AllPostsRequestViewModel(feedService: ServiceLayer.shared.feedService)
    )
    
    // MARK: - Initializers
    
    init(outputSubscriber: FeedScreenOutPutDelegate?) {
        self.outputDelegate = outputSubscriber
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.outputDelegate?.showSearchFriendScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setChilds()
        zeroScreenAction()
    }
    
    // MARK: - Public Methods
    
    public func updatePosts() {
        allPostsVC.updateData()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        view.backgroundColor = ColorPalette.mainBackgroundColor
    }
    
    private func setChilds() {
        addChild(controller: allPostsVC, rootView: feedContainerView)
    }
    
    private func zeroScreenAction() {
        
    }

}

// MARK: - All Posts Delegate

extension FeedScreenContainerVC: PostsFeedDelegate {
    func failureRequest() {
        
    }
}
