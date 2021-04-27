//
//  UserData.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 25.04.2021.
//

import Foundation

public struct UserPostInfo: Codable {
    
    public var id: String?
    public var text: String?
    public var imageUrl: String?
    public var lon: Float?
    public var lat: Float?
    public var likes: Int?
    
    public var author: UserInformation?

    public enum CodingKeys: String, CodingKey {
        case id = "id"
        case text = "text"
        case lon = "lon"
        case lat = "lat"
        case imageUrl = "avatar_url"
        case likes = "likes"
        case author = "author"
    }
}

public struct UserInformation: Codable {
    
    public var id: String?
    public var firstName: String?
    public var lastName: String?
    public var nickname: String?
    public var avatarUrl: String?
    public var birthDay: String?
    
    public enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case nickname = "nickname"
        case avatarUrl = "avatar_url"
        case birthDay = "birth_day"
    }
    
}

public struct AuthTokens: Codable {
    public var accessToken: String?
    public var refreshToken: String?
    
    public enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
