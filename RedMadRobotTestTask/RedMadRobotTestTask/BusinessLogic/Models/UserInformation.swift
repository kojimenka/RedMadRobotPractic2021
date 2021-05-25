//
//  UserInformation.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 15.05.2021.
//

import Foundation

import RedMadRobotTestTaskAPI

public struct UserInformation: Equatable, Codable {
    
    public var id: String = ""
    public var firstName: String = ""
    public var lastName: String = ""
    public var nickname: String?
    public var avatarUrl: URL?
    public var birthDay: Date = Date()
    
}

extension UserInformation {
    
    init(_ model: RedMadRobotTestTaskAPI.UserInformation) {
        id = model.id
        firstName = model.firstName
        lastName = model.lastName
        nickname = model.nickname
        avatarUrl = model.avatarUrl
        birthDay = model.birthDay
    }
    
}

extension RedMadRobotTestTaskAPI.UserInformation {
    
    init(_ model: UserInformation) {
        self.init(
            id: model.id,
            firstName: model.firstName,
            lastName: model.lastName,
            nickname: model.nickname,
            avatarUrl: model.avatarUrl,
            birthDay: model.birthDay
        )
    }
    
}
