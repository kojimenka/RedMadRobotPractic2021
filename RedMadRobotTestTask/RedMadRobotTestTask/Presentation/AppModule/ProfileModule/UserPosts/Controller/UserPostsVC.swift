//
//  UserPostsVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 12.05.2021.
//

import UIKit

protocol UserPostsDelegate: PostsFeedInProfileDelegate {

}

final class UserPostsVC: UIViewController {
    
    // MARK: - IBOutlets

    @IBOutlet private weak var userPostsContainerView: UIView!
    
    // MARK: - Private Properties
    
    private let zeroScreen = ZeroScreenView(screenState: .userPosts)
    
    weak private var delegate: UserPostsDelegate?
    
    lazy private var allPostsVC = PostsFeedVC(
        profileSubscriber: delegate,
        subscriber: self,
        requestViewModel: UserPostsRequestViewModel(feedService: ServiceLayer.shared.feedService)
    )
    
    // MARK: - Init
    
    init(subscriber: UserPostsDelegate?) {
        self.delegate = subscriber
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setChilds()
        setupZeroScreen()
    }
    
    // MARK: - Public Methods
    
    public func setTopInsetInPostCollection(_ inset: CGFloat) {
        allPostsVC.setTopInset(inset)
    }
    
    // MARK: - Private Methods
    
    private func setChilds() {
        addChild(controller: allPostsVC, rootView: userPostsContainerView)
    }

    private func setupZeroScreen() {
        zeroScreen.buttonAction = { [weak self] in
            guard let self = self else { return }
            self.allPostsVC.updateData()
        }
    }
    
}

// MARK: - User Posts Delegate

extension UserPostsVC: PostsFeedDelegate {
    func failureRequest() {
        
    }
}
