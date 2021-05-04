//
//  TestAddFriendEndpoint.swift
//  RedMadRobotTestTaskAPITests
//
//  Created by Дмитрий Марченков on 03.05.2021.
//

import XCTest

@testable import RedMadRobotTestTaskAPI

final class TestAddFriendEndpoint: XCTestCase {

    func testMakeRequest() throws {
        let friendID = "FooBar123"
                
        let endpoint = AddFriendEndpoint(
            friendID: friendID
        )

        let urlRequest = try endpoint.makeRequest()
      
        assertPOST(urlRequest)
        assertURL(urlRequest, "me/friends")
        assertHTTPHeaders(urlRequest, [
            "Content-Type": "application/json"
        ])
        
        assertJsonBody(urlRequest, [
            "user_id": friendID
        ])
    }

}
