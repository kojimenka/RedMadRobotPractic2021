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

/// Класс для оптимизации обновления экранов пользователя
final class UpdateManagerImpl: UpdateManager {
    
    // MARK: - Public Properties
    
    /// Активируется при необходимости обновления новостной ленты
    public var isUpdateFeedNeeded: Bool = false
    
    /// Активируется при необходимости обновления постов пользователя
    public var isUpdateUserPostNeeded: Bool = false
    
    /// Активируется при необходимости обновления любимых постов
    public var isUpdateFavoritePostsNeeded: Bool = false
    
    /// Активируется при необходимости обновления списка друзей
    public var isUpdateFriendsNeeded: Bool = false
    
}
