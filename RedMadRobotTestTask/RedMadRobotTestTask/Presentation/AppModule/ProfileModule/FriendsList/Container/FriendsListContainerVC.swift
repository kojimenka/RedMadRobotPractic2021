//
//  FriendsListVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 09.06.2021.
//

import UIKit

protocol FriendsListContainerVCDelegate: AnyObject {
    func showFindFriendsScreen()
}

final class FriendsListContainerVC: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var friendsListContainerView: UIView!
    @IBOutlet private weak var findMoreFriends: UIButton!
    
    // MARK: - Public Properties
    
    public var changeOffSet: ((CGFloat) -> Void)?
    
    // MARK: - Private Properties
    
    weak private var delegate: FriendsListContainerVCDelegate?
    
    private let userService: UserInfoServiceProtocol
    private var updateManager: UpdateManager
    
    lazy private var allFriendsListVC = AllFriendsListVC(delegate: self)
    private let zeroScreen = ZeroScreenFabric().createZeroModel(state: .friends)
    
    private var zeroScreenContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var zeroScreenTopConstraint = NSLayoutConstraint()
    
    // MARK: - Init
    
    init(
        delegate: FriendsListContainerVCDelegate?,
        updateManager: UpdateManager = ServiceLayer.shared.updateManager,
        userService: UserInfoServiceProtocol = ServiceLayer.shared.userInfoService
    ) {
        self.updateManager = updateManager
        self.userService = userService
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if updateManager.isUpdateFriendsNeeded {
            updateManager.isUpdateFriendsNeeded = false
            allFriendsListVC.makeRequest()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        childsAction()
        setConstraints()
        setupZeroScreen()
        addChilds()
    }
    
    // MARK: - IBActions
    
    @IBAction private func findMoreFriendsAction(_ sender: Any) {
        delegate?.showFindFriendsScreen()
    }
    
    // MARK: - Public Methods
    
    public func setTopInset(_ inset: CGFloat) {
        zeroScreenTopConstraint.constant = inset + navBarHeight
        allFriendsListVC.setTopInset(inset)
    }
    
    // MARK: - Private Methods
    
    private func addChilds() {
        addChild(controller: allFriendsListVC, rootView: friendsListContainerView)
        addChild(controller: zeroScreen, rootView: zeroScreenContainer)
        
        allFriendsListVC.view.alpha = 0.0
        zeroScreen.view.alpha = 0.0
    }
    
    private func showFriendList() {
        allFriendsListVC.view.animateShow()
        zeroScreen.view.animateHide()
    
        view.sendSubviewToBack(zeroScreenContainer)
        
        findMoreFriends.animateShow()
    }
    
    private func showZeroScreen() {
        allFriendsListVC.view.animateHide()
        zeroScreen.view.animateShow()
        
        view.bringSubviewToFront(zeroScreenContainer)
        
        findMoreFriends.animateHide()
    }
    
    private func childsAction() {
        allFriendsListVC.makeRequest()
    }
    
    private func setupZeroScreen() {
        zeroScreen.buttonAction = { [weak self] in
            guard let self = self else { return }
            self.delegate?.showFindFriendsScreen()
        }
    }
    
    private func setConstraints() {
        view.addSubview(zeroScreenContainer)
        
        zeroScreenTopConstraint = zeroScreenContainer.topAnchor.constraint(equalTo: view.topAnchor)
        
        NSLayoutConstraint.activate([
            zeroScreenTopConstraint,
            zeroScreenContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            zeroScreenContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            zeroScreenContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
}

// MARK: - AllFriendsList Delegate

extension FriendsListContainerVC: AllFriendsListVCDelegate {
    
    func deleteFriend(id: String) {
        _ = userService.deleteFriend(friendID: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.updateManager.isUpdateFeedNeeded = true
            case .failure:
                break
            }
        }
    }
    
    func allFriendsDeleted() {
        showZeroScreen()
    }
    
    func getFriends(completion: @escaping ([UserInformation]) -> Void) {
        _ = userService.getUserFriends { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let friends):
                if friends.isEmpty {
                    self.showZeroScreen()
                } else {
                    self.showFriendList()
                    completion(friends)
                }
            case .failure:
                self.showZeroScreen()
            }
        }
        
    }
    
    func scrollViewOffSetChanged(inset: CGFloat) {
        changeOffSet?(inset)
    }
    
}

extension UIViewController {
    func changeChildWithAnimation(newChild: UIViewController, customView: UIView? = nil) {
        DispatchQueue.main.async { [self] in
            UIView.AnimationTransition.removeAllSubviews(rootView: customView == nil ? view : customView!)
            addChild(controller: newChild, rootView: view)
        }
    }
}
