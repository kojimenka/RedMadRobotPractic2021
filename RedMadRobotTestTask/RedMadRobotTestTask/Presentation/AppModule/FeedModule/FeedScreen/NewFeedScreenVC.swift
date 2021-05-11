//
//  ProfileScreenVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

protocol FeedScreenOutPutDelegate: class {
    func showSearchFriendScreen()
}

final class NewFeedScreenVC: UIViewController {
    
    // MARK: - IBOutlets

    @IBOutlet private weak var feedContainerView: UIView!
    
    // MARK: - Private Properties

    weak private var outputDelegate: FeedScreenOutPutDelegate?
    private let allPostsVC = PostsFeedVC(state: .feedScreen)
    
    // MARK: - Initializers
    
    init(outputSubscriber: FeedScreenOutPutDelegate?) {
        self.outputDelegate = outputSubscriber
        super.init(nibName: R.nib.newFeedScreenVC.name, bundle: R.nib.newFeedScreenVC.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
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
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = ColorPalette.mainBackgroundColor
    }
    
    private func setChilds() {
        addChild(controller: allPostsVC, rootView: feedContainerView)
    }
    
    private func zeroScreenAction() {
        allPostsVC.showFindFriendsScreen = { [weak self] in
            guard let self = self else { return }
            self.outputDelegate?.showSearchFriendScreen()
        }
    }

}
