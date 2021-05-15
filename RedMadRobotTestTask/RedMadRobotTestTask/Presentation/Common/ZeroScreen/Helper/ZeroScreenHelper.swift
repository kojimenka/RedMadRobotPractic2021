//
//  ZeroScreenHelper.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 08.05.2021.
//

import UIKit

enum ZeroScreenVariations {
    case feedScreen
    case userPosts
    case userFavoritePosts
    case friends
}

struct ZeroScreenModel {
    let image: UIImage?
    let titleText: String?
    let descriptionText: String?
    let buttonTitle: String?
}

struct ZeroScreenFabric {
    public func createZeroModel(state: ZeroScreenVariations) -> ZeroScreenModel {
        switch state {
        case .feedScreen:
            return ZeroScreenModel(
                image: R.image.profileZeroScreenImage(),
                titleText: "Пустота",
                descriptionText: "Вам нужны друзья, чтобы\nлента стала живой",
                buttonTitle: "Найти друзей"
            )
        case .userPosts:
            return ZeroScreenModel(
                image: R.image.profileZeroScreenImage(),
                titleText: "Пустота",
                descriptionText: "Если молчать, люди никогда\nне узнают о вас",
                buttonTitle: "Создать пост"
            )
        case .userFavoritePosts:
            return ZeroScreenModel(
                image: R.image.profileZeroScreenImage(),
                titleText: "Пустота",
                descriptionText: "Вы ещё не поставили ни одного лайка\n, но можете из ленты",
                buttonTitle: "Создать пост"
            )
        case .friends:
            return ZeroScreenModel(
                image: nil,
                titleText: "Пустота",
                descriptionText: "Вы пока одиноки в сервисе, но это можно исправить",
                buttonTitle: "Найти друзей"
            )
        }
    }
}
