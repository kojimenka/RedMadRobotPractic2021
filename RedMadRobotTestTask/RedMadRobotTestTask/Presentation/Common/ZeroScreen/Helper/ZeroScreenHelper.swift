//
//  ZeroScreenHelper.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 08.05.2021.
//

import UIKit

enum ZeroScreenVariations {
    case genericError
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

/// Фабрика для создания любого Zero Screen-a
final class ZeroScreenFabric {
    
    public func createZeroModel(
        state: ZeroScreenVariations,
        buttonAction: (() -> Void)? = nil
    ) -> ZeroScreenVC {
        
        let model: ZeroScreenModel
        
        switch state {
        case .genericError:
            model = ZeroScreenModel(
                image: R.image.profileZeroScreenImage(),
                titleText: "Ошибка",
                descriptionText: "Упс, у нас проблемы",
                buttonTitle: "Обновить"
            )
        case .feedScreen:
            model = ZeroScreenModel(
                image: R.image.profileZeroScreenImage(),
                titleText: "Пустота",
                descriptionText: "Вам нужны друзья, чтобы\nлента стала живой",
                buttonTitle: "Найти друзей"
            )
        case .userPosts:
            model = ZeroScreenModel(
                image: R.image.profileZeroScreenImage(),
                titleText: "Пустота",
                descriptionText: "Если молчать, люди никогда\nне узнают о вас",
                buttonTitle: "Создать пост"
            )
        case .userFavoritePosts:
            model = ZeroScreenModel(
                image: R.image.profileZeroScreenImage(),
                titleText: "Пустота",
                descriptionText: "Вы ещё не поставили ни одного лайка,\nно можете из ленты",
                buttonTitle: "Перейти к ленте"
            )
        case .friends:
            model = ZeroScreenModel(
                image: nil,
                titleText: "Пустота",
                descriptionText: "Вы пока одиноки в сервисе, но это можно исправить",
                buttonTitle: "Найти друзей"
            )
        }
        
        return ZeroScreenVC(zeroScreenModel: model, buttonAction: buttonAction)
    }
    
}
