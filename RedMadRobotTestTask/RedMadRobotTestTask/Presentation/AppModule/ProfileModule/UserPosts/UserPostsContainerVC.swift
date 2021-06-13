//
//  UserPostsContainerVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 29.05.2021.
//

import UIKit

final class UserPostsContainerVC: MainPostScreenVC {
    
    // MARK: - Private Methods
    
    private let zeroScreen = ZeroScreenFabric().createZeroModel(state: .userPosts)
    private let feedService: FeedServiceProtocol
    
    // MARK: - Init
    
    init(
        feedService: FeedServiceProtocol = ServiceLayer.shared.feedService
    ) {
        self.feedService = feedService
        super.init(zeroScreen: zeroScreen)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if updateManager.isUpdateUserPostNeeded == true {
            super.userPostsVC.requestData()
            updateManager.isUpdateUserPostNeeded = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupZeroScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupZeroScreen()
        super.userPostsVC.requestData()
    }
    
    // MARK: - Public Methods
    
    override func getPosts(completion: @escaping (Result<[PostInfo], Error>) -> Void) {
        _ = feedService.getUserPosts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let content):
                if content.isEmpty {
                    completion(.failure(LoginValidatorError.emptyLogin))
                    self.showZeroScreen()
                } else {
                    self.showPostsScreen()
                    completion(result)
                }
            case .failure:
                completion(result)
                self.showZeroScreen()
            }
        }
    }
    
    public func updateLikes() {
        super.userPostsVC.reloadTableView()
    }
    
    // MARK: - Private Methods
    
    private func setupZeroScreen() {
        zeroScreen.buttonAction = { [weak self] in
            guard let self = self,
                  let appTabBar = self.navigationController?.tabBarController as? AppTabBarController
            else { return }
            appTabBar.presentPostScreen()
        }
    }
    
}
