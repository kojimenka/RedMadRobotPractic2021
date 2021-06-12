//
//  AuthMockModels.swift
//  RedMadRobotTestTaskTests
//
//  Created by Дмитрий Марченков on 06.05.2021.
//

import Foundation

@testable import RedMadRobotTestTask

@testable import RedMadRobotTestTaskAPI

final class AuthMockModels {
    
    // MARK: - Properties
    
    public private(set) var email = "FooBar@gmail.com"
    public private(set) var password = "FooBar"
    
    public private(set) var tokenData = RedMadRobotTestTaskAPI.AuthTokens(
        accessToken: "FooBar123",
        refreshToken: "FizBuz123"
    )
    
    public private(set) var differentTokenData = RedMadRobotTestTaskAPI.AuthTokens(
        accessToken: "FooBar256",
        refreshToken: "FizBuz799"
    )
    
    public private(set) var userStub = RedMadRobotTestTaskAPI.UserInformation(
        id: "1234",
        firstName: "Foo",
        lastName: "Bar",
        nickname: "FooBar",
        avatarUrl: nil,
        birthDay: Date()
    )
    
    lazy public private(set) var usersStubArray = [userStub]

    lazy public private(set) var postStub = RedMadRobotTestTaskAPI.PostInfo(
        id: "5678",
        text: "Test FooBar Test",
        imageUrl: nil,
        lon: 1234,
        lat: 5678,
        likes: 1000,
        author: userStub
    )
    
    lazy public private(set) var postsStubArray = [postStub]
}
