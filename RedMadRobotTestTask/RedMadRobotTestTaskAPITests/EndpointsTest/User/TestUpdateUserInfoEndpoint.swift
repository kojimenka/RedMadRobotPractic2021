//
//  TestUpdateUserInfoEndpoint.swift
//  RedMadRobotTestTaskAPITests
//
//  Created by Дмитрий Марченков on 07.05.2021.
//

import XCTest

@testable import RedMadRobotTestTaskAPI

final class TestUpdateUserInfoEndpoint: XCTestCase {

    func testMakeRequest() throws {
        
        let userInfo = AddUserInformationModel(
            firstName: "Foo",
            lastName: "Bar",
            nickname: "kojimenka",
            imageData: nil,
            birthDay: Date()
        )
        
        let endpoint = UpdateUserInfoEndpoint(
            user: userInfo
        )

        let urlRequest = try endpoint.makeRequest()
      
        assertPATCH(urlRequest)
        assertURL(urlRequest, "me")
    }

}
