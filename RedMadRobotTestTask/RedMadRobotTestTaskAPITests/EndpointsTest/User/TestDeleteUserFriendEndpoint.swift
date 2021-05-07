//
//  TestDeleteUserFriendEndpoint.swift
//  RedMadRobotTestTaskAPITests
//
//  Created by Дмитрий Марченков on 03.05.2021.
//

import XCTest

@testable import RedMadRobotTestTaskAPI

final class TestDeleteUserFriendEndpoint: XCTestCase {

    func testMakeRequest() throws {
        let userID = "FooBar"
        let endpoint = DeleteUserFriendEndpoint(userId: userID)

        let urlRequest = try endpoint.makeRequest()
      
        assertDELETE(urlRequest)
        XCTAssertNil(urlRequest.httpBody)
        assertURL(urlRequest, "me/friends/\(userID)")
    }

}
