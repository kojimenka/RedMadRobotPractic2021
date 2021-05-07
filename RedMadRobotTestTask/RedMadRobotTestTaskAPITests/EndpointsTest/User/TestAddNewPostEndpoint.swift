//
//  TestAddNewPostEndpoint.swift
//  RedMadRobotTestTaskAPITests
//
//  Created by Дмитрий Марченков on 03.05.2021.
//

import XCTest

@testable import RedMadRobotTestTaskAPI

final class TestAddNewPostEndpoint: XCTestCase {

    func testMakeRequest() throws {
        
        let userInfo = UserInformation(
            id: "1234",
            firstName: "Foo",
            lastName: "Bar",
            nickname: "kojimenka",
            avatarUrl: nil,
            birthDay: "123"
        )
        
        let post = PostInfo(
            id: "1234",
            text: nil,
            avatarUrl: nil,
            lon: nil,
            lat: nil,
            likes: 0,
            author: userInfo
        )
        
        let token = "FooBar123"
        
        let endpoint = AddNewPostEndpoint(
            postInfo: post,
            token: token
        )

        let urlRequest = try endpoint.makeRequest()
      
        assertPOST(urlRequest)
        assertURL(urlRequest, "https://interns2021.redmadrobot.com/me/posts")
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
        
        let post = PostInfo(
            id: "1234",
            text: nil,
            avatarUrl: nil,
            lon: nil,
            lat: nil,
            likes: 0,
            author: userInfo
        )
        
        let token: String? = nil
        
        let endpoint = AddNewPostEndpoint(
            postInfo: post,
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
