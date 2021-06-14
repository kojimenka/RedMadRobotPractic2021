//
//  AuthTokens.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 06.06.2021.
//

import Foundation

import RedMadRobotTestTaskAPI

/// Токены для работы с API
public struct AuthTokens: Codable, Equatable {
    
    public var accessToken: String
    public var refreshToken: String
    
}

// MARK: - Мапперы для связывания структур между таргетами

extension AuthTokens {
    
    init(_ model: RedMadRobotTestTaskAPI.AuthTokens) {
        self.accessToken = model.accessToken
        self.refreshToken = model.refreshToken
    }
    
}
