//
//  MockChangeUserInfo.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 28.04.2021.
//

import Foundation

import RedMadRobotTestTaskAPI

final class MockChangeUserInfo {
    
    private let userService = ServiceLayer.shared.userInfoService
    
    public func changeUserInfo() {
        let jsonString = """
                {
                    "first_name": "Dima",
                    "last_name":  "Marchenkov",
                    "nickname":   "kojimenka",
                    "birth_day":  "2001-05-26",
                    "avatar_url": ""
                }
                """
        
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        guard let user = try? decoder.decode(UserInformation.self, from: jsonData) else { return }
        
        _ = userService.updateUserInfo(user: user) { result in
            switch result {
            case .success(let info):
                print("Check Success \(info)")
            case .failure(let err):
                print("Check Failure \(err.localizedDescription)")
            }
        }
    }
    
}
