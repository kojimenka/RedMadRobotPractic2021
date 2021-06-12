//
//  AllFriendsListVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 09.06.2021.
//

import UIKit

protocol AllFriendsListVCDelegate: AnyObject {
    func getFriends(completion: @escaping ([UserInformation]) -> Void )
    func scrollViewOffSetChanged(inset: CGFloat)
    func allFriendsDeleted()
    func deleteFriend(id: String)
}

final class AllFriendsListVC: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private  weak var tableView: UITableView!
    
    // MARK: - Public Properties
    
    weak private var delegate: AllFriendsListVCDelegate?
    
    // MARK: - Private Properties
    
    private var dataSource: AllFriendsListDataSource
    
    private var topInset: CGFloat = 0.0
    private var isFirstLayout = true
    
    // MARK: - Init
    
    init(
        delegate: AllFriendsListVCDelegate?,
        dataSource: AllFriendsListDataSource = AllFriendsListDataSourceImpl()
    ) {
        self.dataSource = dataSource
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard isFirstLayout == true else { return }
        tableView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        tableView.setContentOffset(CGPoint(x: 0, y: -topInset), animated: false)
        isFirstLayout = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        dataSourceActions()
    }
    
    // MARK: - Public Methods
    
    public func setTopInset(_ inset: CGFloat) {
        topInset = inset
    }
    
    public func makeRequest() {
        delegate?.getFriends(completion: { [weak self] allFriends in
            guard let self = self else { return }
            self.dataSource.allFriends = allFriends
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    // MARK: - Private Methods
    
    private func setupTableView() {
        tableView.dataSource = dataSource
        tableView.rowHeight = 64.0
        
        tableView.register(
            FriendTableViewCell.nib(),
            forCellReuseIdentifier: FriendTableViewCell.identifier
        )
    }
    
    private func dataSourceActions() {
        dataSource.allFriendsDeleted = { [weak self] in
            guard let self = self else { return }
            self.delegate?.allFriendsDeleted()
        }
        
        dataSource.deleteFriend = { [weak self] id in
            guard let self = self else { return }
            self.delegate?.deleteFriend(id: id)
        }
    }

}

// MARK: - UITableView Delegate

extension AllFriendsListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - UIScrollView Delegate

extension AllFriendsListVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isFirstLayout == false else { return }
        delegate?.scrollViewOffSetChanged(inset: scrollView.contentOffset.y + topInset)
    }
    
}
