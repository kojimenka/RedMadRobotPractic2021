//
//  TestGetUserFriendsEndpoint.swift
//  RedMadRobotTestTaskAPITests
//
//  Created by Дмитрий Марченков on 03.05.2021.
//

import XCTest

@testable import RedMadRobotTestTaskAPI

final class TestGetUserFriendsEndpoint: XCTestCase {

    func testMakeRequest() throws {
        let endpoint = GetUserFriendsEndpoint()

        let urlRequest = try endpoint.makeRequest()
      
        assertGET(urlRequest)
        XCTAssertNil(urlRequest.httpBody)
        assertURL(urlRequest, "me/friends")
    }

}
