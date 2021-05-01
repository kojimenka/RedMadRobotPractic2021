//
//  MockPostData.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 29.04.2021.
//

import Foundation

import RedMadRobotTestTaskAPI

final class MockPostData {
    
    private let userService = ServiceLayer.shared.userInfoService
    
    public func addNewPost() {
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
        
        print("Check", post)
        
        _ = userService.addPost(postInfo: post) { result in
            switch result {
            case .success(let info):
                print("Check Success \(info)")
            case .failure(let err):
                print("Check Failure \(err.localizedDescription)")
            }
        }
    }
    
}
