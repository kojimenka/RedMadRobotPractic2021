//
//  TokenManager.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 06.06.2021.
//

import Foundation

public protocol TokenManager {
    var accessToken: String? { get set }
}

final class TokenManagerImpl: TokenManager {
    
    // MARK: - Public Properties
    
    public var accessToken: String?
    
}
