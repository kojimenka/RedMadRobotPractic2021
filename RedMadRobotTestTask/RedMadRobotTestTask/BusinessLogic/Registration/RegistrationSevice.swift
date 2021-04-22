//
//  RegistrationSevice.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 20.04.2021.
//

import Foundation

// swiftlint:disable line_length
final class MockData {
    
    // MARK: - Properties
    public static var shared = MockData()
    
    public private (set) var testUser = UserInfo(name: "", login: "", email: "", password: "", city: "", birthday: Date())

    // MARK: - Init
    private init() {}
}

struct UserInfo {
    let name: String
    let login: String
    let email: String
    let password: String
    let city: String
    let birthday: Date
}

final class RegistrationService {
    
    // MARK: - Properties
    public static var shared = RegistrationService()
    private let errorManager = ErrorManager.shared
    
    private var dummyRes: Bool {
        return Int.random(in: 0...1) == 0 ? false : true // True - Success res, False - failure res
    }
    
    enum CustomErrors: Error {
        case timeWaring
    }
    
    // MARK: - Init
    private init () {}
    
    // MARK: - Methods
    public func registrateUser(user: UserInfo, completion: @escaping (Result<String, Error>) -> Void ) {
        if dummyRes {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                completion(.success(""))
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.errorManager.presentError(error: .errorWithTitle(title: "Превышен лимит ожидания"))
                completion(.failure(CustomErrors.timeWaring))
            }
        }
    }
}
