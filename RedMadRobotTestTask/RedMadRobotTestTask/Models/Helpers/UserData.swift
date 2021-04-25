//
//  UserData.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 25.04.2021.
//

import Foundation

struct UserInfo {
    let name: String
    let login: String
    let email: String
    let password: String
    let city: String
    let birthday: Date
    
    static func createMockUser() -> UserInfo {
        return UserInfo(
            name: "Foo",
            login: "Bar",
            email: "test@gmail.com",
            password: "password",
            city: "N Town",
            birthday: Date()
        )
    }
}
