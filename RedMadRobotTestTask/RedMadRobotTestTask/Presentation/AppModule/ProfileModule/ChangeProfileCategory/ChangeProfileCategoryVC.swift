//
//  ChangeProfileCategoryVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 07.05.2021.
//

import UIKit

enum ProfileCategories {
    case posts
    case favoritePosts
    case friends
}

protocol ChangeProfileCategoryDelegate: AnyObject {
    func changeCategory(_ category: ProfileCategories)
}

final class ChangeProfileCategoryVC: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var postButton: UIButton!
    @IBOutlet private weak var favoritePostsButton: UIButton!
    @IBOutlet private weak var friendsButton: UIButton!
    
    // MARK: - Private Properties
    
    weak private var delegate: ChangeProfileCategoryDelegate?
    
    private struct ButtonInfo {
        let button: UIButton
        let category: ProfileCategories
    }
    
    lazy private var allButtonsInfo =
        [
            ButtonInfo(button: postButton, category: .posts),
            ButtonInfo(button: favoritePostsButton, category: .favoritePosts),
            ButtonInfo(button: friendsButton, category: .friends)
        ]
    
    // MARK: - Init
    
    init(subscriber: ChangeProfileCategoryDelegate) {
        self.delegate = subscriber
        super.init(
            nibName: R.nib.changeProfileCategoryVC.name,
            bundle: R.nib.changeProfileCategoryVC.bundle
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        initialChoice()
    }
    
    // MARK: - IBActions
    
    @IBAction private func buttonAction(_ sender: UIButton?) {
        for buttonInfo in allButtonsInfo {
            let isChosenButton = buttonInfo.button == sender
            let titleColor = isChosenButton ? UIColor.black : R.color.middle_grey()
            
            if isChosenButton {
                delegate?.changeCategory(buttonInfo.category)
            }
            
            buttonInfo.button.setTitleColor(titleColor, for: .normal)
        }
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 24.0
    }
    
    private func initialChoice() {
        buttonAction(allButtonsInfo.first?.button)
    }
    
}
