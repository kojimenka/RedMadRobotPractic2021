//
//  RegistrationSevice.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 20.04.2021.
//

import Foundation

protocol RegistrationServiceProtocol {
    
}

final class RegistrationService {
    
    // MARK: - Private Properties

    private let errorManager = ErrorManager.shared
    
    private var dummyRes: Bool {
        return Int.random(in: 0...1) == 0 ? false : true // True - Success res, False - failure res
    }
    
    private enum CustomErrors: Error {
        case timeWaring
    }
    
    // MARK: - Public Methods
    
    public func signInUser(user: UserInfo, completion: @escaping (Result<String, Error>) -> Void) {
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
