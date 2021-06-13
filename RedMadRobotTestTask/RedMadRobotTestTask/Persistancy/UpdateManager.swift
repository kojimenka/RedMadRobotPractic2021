//
//  UpdateManager.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 13.06.2021.
//

import Foundation

protocol UpdateManager {
    var isUpdateFeedNeeded: Bool { get set }
    var isUpdateUserPostNeeded: Bool { get set }
    var isUpdateFavoritePostsNeeded: Bool { get set }
    var isUpdateFriendsNeeded: Bool { get set }
}

final class UpdateManagerImpl: UpdateManager {
    
    // MARK: - Public Properties
    
    public var isUpdateFeedNeeded: Bool = false
    public var isUpdateUserPostNeeded: Bool = false
    public var isUpdateFavoritePostsNeeded: Bool = false
    public var isUpdateFriendsNeeded: Bool = false
    
}
