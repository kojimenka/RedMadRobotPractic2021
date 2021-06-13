//
//  AddUserInformationModel.swift
//  RedMadRobotTestTaskAPI
//
//  Created by Дмитрий Марченков on 13.06.2021.
//

import Foundation

public struct AddUserInformationModel: Codable, Equatable {
    
    public init(
        firstName: String,
        lastName: String,
        nickname: String?,
        imageData: Data?,
        birthDay: Date
    ) {
        self.firstName = firstName
        self.lastName = lastName
        self.nickname = nickname
        self.imageData = imageData
        self.birthDay = birthDay
    }
    
    public var firstName: String
    public var lastName: String
    public var nickname: String?
    public var imageData: Data?
    public var birthDay: Date
    
}
