//
//  FeedScreenVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

final class FeedScreenVC: UIViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var zeroScreenView: ZeroScreenView!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Methods
    private func setupViews() {
        zeroScreenView.delegate = self
    }

}

// MARK: - Zero Screen Delegate
extension FeedScreenVC: ZeroScreenViewDelegate {
    func updateButtonAction() {
        print("Update")
    }
}
