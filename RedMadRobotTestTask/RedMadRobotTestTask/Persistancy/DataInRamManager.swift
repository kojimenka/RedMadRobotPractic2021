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

/// Класс для хранения данных которые нужны только во время работы приложения 
final class DataInRamManagerImpl: DataInRamManager {
    
    // MARK: - Public Properties

    public var accessToken: String?
    
    /// Пароль хранится в памяти устройства для возможности обновления токенов
    public var password: Data?
    
}
