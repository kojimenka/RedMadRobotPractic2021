//
//  GetUserPosts.swift
//  RedMadRobotTestTaskAPI
//
//  Created by Дмитрий Марченков on 26.04.2021.
//

import Apexy

// swiftlint:disable line_length
public struct GetUserPosts: JsonEndpoint {
    
    public typealias Content = [UserPostInfo]

    public init() {}
    
    let token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJBdXRoZW50aWNhdGlvbiIsImF1ZCI6ImludGVybnNoaXAtYXVkaWVuY2UiLCJpc3MiOiJodHRwczovL2ludGVybnMyMDIxLnJlZG1hZHJvYm90LmNvbSIsImlkIjoiMTJmNTRlMzEtOTkzNi00ZmM3LTgyMGEtYjg3YTNhZGRlYTg2IiwiZXhwIjoxNjE5NTYzNzcxfQ.m4HVnjA8b7I-KFvPeuQlh2Uc9lYYg64qUx2u-x3RX_36v5A-jHYxwaK9Z_2oX6eFBeikmaAPAfDqPcymlYPzuQ"
    
    public func makeRequest() throws -> URLRequest {
        
        // create get request
        let url = URL(string: "me/posts")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }

}
