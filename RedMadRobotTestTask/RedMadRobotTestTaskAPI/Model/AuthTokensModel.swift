//
//  AuthTokensModel.swift
//  RedMadRobotTestTaskAPI
//
//  Created by Дмитрий Марченков on 28.04.2021.
//

import Foundation

public struct AuthTokens: Codable, Equatable {
    
    public var accessToken: String
    public var refreshToken: String
    
}
