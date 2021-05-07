//
//  TestRefreshUserTokenEndpoint.swift
//  RedMadRobotTestTaskAPITests
//
//  Created by Дмитрий Марченков on 03.05.2021.
//

import XCTest

@testable import RedMadRobotTestTaskAPI

final class TestRefreshUserTokenEndpoint: XCTestCase {

    func testMakeRequest() throws {
        let token = "FooBar"
        
        let endpoint = RefreshUserTokenEndpoint(
            token: token
        )

        let urlRequest = try endpoint.makeRequest()
      
        assertPOST(urlRequest)
        assertURL(urlRequest, "auth/refresh")
        assertHTTPHeaders(urlRequest, [
            "Content-Type": "application/json"
        ])
        
        assertJsonBody(
            urlRequest,
            [
            "token": token
            ]
        )
    }

}
