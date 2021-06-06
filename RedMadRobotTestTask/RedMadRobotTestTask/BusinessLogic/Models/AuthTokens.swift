//
//  AuthTokens.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 06.06.2021.
//

import Foundation

import RedMadRobotTestTaskAPI

public struct AuthTokens: Codable, Equatable {
    
    public var accessToken: String
    public var refreshToken: String
    
}

extension AuthTokens {
    
    init(_ model: RedMadRobotTestTaskAPI.AuthTokens) {
        self.accessToken = model.accessToken
        self.refreshToken = model.refreshToken
    }
    
}
