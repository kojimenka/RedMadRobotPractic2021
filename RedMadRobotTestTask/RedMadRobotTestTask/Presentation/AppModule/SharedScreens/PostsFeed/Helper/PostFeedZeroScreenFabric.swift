//
//  PostFeedZeroScreenFabric.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 11.05.2021.
//

import UIKit

// Все экраны на которых PostScreen используется как чайлд

enum PostsScreenState {
    case feedScreen
    case userPosts
    case userFavoritePosts
}

// Для каждого экрана должен быть уникальный чайлд

struct PostFeedZeroScreenFabric {
    static func createZeroScreen(state: PostsScreenState) -> ZeroScreenView {
        switch state {
        case .feedScreen:
            return ZeroScreenView(screenState: .feedScreen)
        case .userFavoritePosts:
            return ZeroScreenView(screenState: .userFavoritePosts)
        case .userPosts:
            return ZeroScreenView(screenState: .userPosts)
        }
    }
}
