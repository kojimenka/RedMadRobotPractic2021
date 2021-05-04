//
//  TestRemoveLikeFromPostEndpoint.swift
//  RedMadRobotTestTaskAPITests
//
//  Created by Дмитрий Марченков on 03.05.2021.
//

import XCTest

@testable import RedMadRobotTestTaskAPI

final class TestRemoveLikeFromPostEndpoint: XCTestCase {

    func testMakeRequest() throws {
        let postID = "FooBar123"
        
        let endpoint = RemoveLikeFromPostEndpoint(postID: postID)

        let urlRequest = try endpoint.makeRequest()
      
        assertDELETE(urlRequest)
        XCTAssertNil(urlRequest.httpBody)
        assertURL(urlRequest, "feed/\(postID)/like")
    }

}
