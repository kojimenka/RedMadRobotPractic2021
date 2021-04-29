//
//  UserInformationModel.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 25.04.2021.
//

import Foundation

public struct UserInformation: Codable {
    
    public var id: String
    public var firstName: String
    public var lastName: String
    public var nickname: String?
    public var avatarUrl: URL?
    public var birthDay: String
    
}
