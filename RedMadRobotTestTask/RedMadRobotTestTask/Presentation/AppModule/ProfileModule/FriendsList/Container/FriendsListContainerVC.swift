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
    
    lazy private var allFriendsListVC = AllFriendsListVC(delegate: self)
    weak private var delegate: FriendsListContainerVCDelegate?
    private let userService: UserInfoServiceProtocol
    
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
        userService: UserInfoServiceProtocol = ServiceLayer.shared.userInfoService
    ) {
        self.userService = userService
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        childsAction()
        setConstraints()
        setupZeroScreen()
    }
    
    // MARK: - IBActions
    
    @IBAction private func findMoreFriendsAction(_ sender: Any) {
        delegate?.showFindFriendsScreen()
    }
    
    // MARK: - Public Methods
    
    public func setTopInset(_ inset: CGFloat) {
        zeroScreenTopConstraint.constant = inset
        allFriendsListVC.setTopInset(inset)
    }
    
    // MARK: - Private Methods
    
    private func showFriendList() {
        addChild(controller: allFriendsListVC, rootView: friendsListContainerView)
        findMoreFriends.animateShow()
    }
    
    private func showZeroScreen() {
        changeChildWithAnimation(newChild: zeroScreen, customView: zeroScreenContainer)
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
        
        view.sendSubviewToBack(zeroScreenContainer)
    }
    
}

// MARK: - AllFriendsList Delegate

extension FriendsListContainerVC: AllFriendsListVCDelegate {
    
    func deleteFriend(id: String) {
        _ = userService.deleteFriend(friendID: id) { _ in }
    }
    
    func allFriendsDeleted() {
        showZeroScreen()
    }
    
    func getFriends(completion: @escaping ([UserInformation]) -> Void) {
        _ = userService.getUserFriends { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let friends):
                self.showFriendList()
                completion(friends)
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
