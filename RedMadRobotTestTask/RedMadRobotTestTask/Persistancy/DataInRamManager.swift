//
//  TokenManager.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 06.06.2021.
//

import Foundation

public protocol DataInRamManager {
    var accessToken: String? { get set }
    var password: Data? { get set }
}

final class DataInRamManagerImpl: DataInRamManager {
    
    // MARK: - Public Properties
    
    public var accessToken: String?
    public var password: Data?
    
}
