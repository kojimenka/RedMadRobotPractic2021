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
    
//    public func changeUserInfo() {
//        let jsonString = """
//                    {
//                        "id": "",
//                        "first_name": "Dima",
//                        "last_name": "Marchenkov",
//                        "birth_day": "2001-05-26",
//                        "nickname": "kojimenka",
//                        "avatar_url": null
//                    }
//                """
//        
//        let jsonData = jsonString.data(using: .utf8)!
//        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
//        
//        let user: UserInformation
//        
//        do {
//            user = try decoder.decode(UserInformation.self, from: jsonData)
//        } catch let error {
//            print("Check Failure \(error.localizedDescription)")
//            return
//        }
//        
//        print("Check", user)
//        
//        _ = userService.updateUserInfo(user: user) { result in
//            switch result {
//            case .success(let info):
//                print("Check Success \(info)")
//            case .failure(let err):
//                print("Check Failure \(err.localizedDescription)")
//            }
//        }
//    }
    
}
