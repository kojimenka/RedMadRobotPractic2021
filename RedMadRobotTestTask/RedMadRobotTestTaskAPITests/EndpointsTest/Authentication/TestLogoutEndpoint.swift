//
//  TestLogoutEndpoint.swift
//  RedMadRobotTestTaskAPITests
//
//  Created by Дмитрий Марченков on 03.05.2021.
//

import XCTest

@testable import RedMadRobotTestTaskAPI

final class TestLogoutEndpoint: XCTestCase {

    func testMakeRequest() throws {
        let endpoint = LogoutEndpoint()

        let urlRequest = try endpoint.makeRequest()
      
        assertPOST(urlRequest)
        XCTAssertNil(urlRequest.httpBody)
        assertURL(urlRequest, "auth/logout")
    }

}
