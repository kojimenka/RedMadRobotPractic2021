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
        
        let jsonString = """
                    {
                        "id": "c73ad791-ffdf-4a81-903b-cef52b25f0f9",
                        "text": "Hello, World",
                        "image_url": null,
                        "lon": null,
                        "lat": null,
                        "likes": 6,
                        "author": {
                            "id": "",
                            "first_name": "",
                            "last_name": "",
                            "birth_day": "",
                            "nickname": "",
                            "avatar_url": null
                        }
                    }
                """
        
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let post: PostInfo
        
        do {
            post = try decoder.decode(PostInfo.self, from: jsonData)
        } catch let error {
            print("Check Failure \(error.localizedDescription)")
            return
        }
        
        let token = "FooBar123"
        
        let endpoint = AddNewPostEndpoint(
            postInfo: post,
            token: token
        )

        let urlRequest = try endpoint.makeRequest()
      
        assertPOST(urlRequest)
        assertURL(urlRequest, "https://interns2021.redmadrobot.com/me/posts")
    }

}
