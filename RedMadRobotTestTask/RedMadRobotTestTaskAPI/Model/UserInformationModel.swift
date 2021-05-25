//
//  UserInformationModel.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 25.04.2021.
//

import Foundation

public struct UserInformation: Codable, Equatable {
    
    public init(
        id: String,
        firstName: String,
        lastName: String,
        nickname: String?,
        avatarUrl: URL?,
        birthDay: Date
    ) {
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.nickname = nickname
        self.avatarUrl = avatarUrl
        self.birthDay = birthDay
        
    }
    
    public var id: String
    public var firstName: String
    public var lastName: String
    public var nickname: String?
    public var avatarUrl: URL?
    public var birthDay: Date
    
}
