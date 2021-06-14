//
//  AddUserModel.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 13.06.2021.
//

import Foundation

import RedMadRobotTestTaskAPI

/// Модель для добавления информации о пользователе
public struct AddUserInformationModel: Codable, Equatable {
    
    public var firstName: String = ""
    public var lastName: String = ""
    public var nickname: String?
    public var imageData: Data?
    public var birthDay: Date = Date()
    
}

// MARK: - Мапперы для связывания структур между таргетами

extension AddUserInformationModel {
    
    init(_ model: RedMadRobotTestTaskAPI.AddUserInformationModel) {
        firstName = model.firstName
        lastName = model.lastName
        nickname = model.nickname
        imageData = model.imageData
        birthDay = model.birthDay
    }
    
}

extension RedMadRobotTestTaskAPI.AddUserInformationModel {
    
    init(_ model: AddUserInformationModel) {
        self.init(
            firstName: model.firstName,
            lastName: model.lastName,
            nickname: model.nickname,
            imageData: model.imageData,
            birthDay: model.birthDay
        )
    }
    
}
