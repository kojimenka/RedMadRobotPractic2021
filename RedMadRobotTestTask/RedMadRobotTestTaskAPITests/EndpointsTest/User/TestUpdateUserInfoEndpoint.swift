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
        
        let userInfo = UserInformation(
            id: "1234",
            firstName: "Foo",
            lastName: "Bar",
            nickname: "kojimenka",
            avatarUrl: nil,
            birthDay: "123"
        )

        let token = "FooBar123"
        
        let endpoint = UpdateUserInfoEndpoint(
            user: userInfo,
            token: token
        )

        let urlRequest = try endpoint.makeRequest()
      
        assertPATCH(urlRequest)
        assertURL(urlRequest, "https://interns2021.redmadrobot.com/me")
    }

    func testMakeFailureRequest() throws {
        
        let userInfo = UserInformation(
            id: "1234",
            firstName: "Foo",
            lastName: "Bar",
            nickname: "kojimenka",
            avatarUrl: nil,
            birthDay: "123"
        )
        
        let token: String? = nil
        
        let endpoint = UpdateUserInfoEndpoint(
            user: userInfo,
            token: token
        )
        
        do {
            _ = try endpoint.makeRequest()
            XCTFail("Failure work wrong")
        } catch let error {
            XCTAssertEqual(error.localizedDescription, DefaultServiceErrors.nilToken.localizedDescription)
        }
    }
}
