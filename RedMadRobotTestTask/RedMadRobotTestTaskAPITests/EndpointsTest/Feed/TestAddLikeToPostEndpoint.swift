//
//  TestAddLikeToPostEndpoint.swift
//  RedMadRobotTestTaskAPITests
//
//  Created by Дмитрий Марченков on 03.05.2021.
//

import XCTest

@testable import RedMadRobotTestTaskAPI

final class TestAddLikeToPostEndpoint: XCTestCase {

    func testMakeRequest() throws {
        let postID = "FooBar123"
        
        let endpoint = AddLikeToPostEndpoint(postID: postID)

        let urlRequest = try endpoint.makeRequest()
      
        assertPOST(urlRequest)
        XCTAssertNil(urlRequest.httpBody)
        assertURL(urlRequest, "feed/\(postID)/like")
    }

}
