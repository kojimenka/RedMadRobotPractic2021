//
//  PostInfo.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 16.05.2021.
//

import Foundation

import RedMadRobotTestTaskAPI

public struct PostInfo: Codable, Equatable {
    
    public var id: String = ""
    public var text: String?
    public var imageUrl: URL?
    public var lon: Float?
    public var lat: Float?
    public var likes: Int = 0
    public var isLikedPost: Bool = false
    
    public var author: UserInformation
}

extension PostInfo {
    
    init(_ model: RedMadRobotTestTaskAPI.PostInfo) {
        id = model.id
        text = model.text
        imageUrl = model.imageUrl
        lon = model.lon
        lat = model.lat
        likes = model.likes
        author = UserInformation(model.author)
    }
    
}

extension RedMadRobotTestTaskAPI.PostInfo {
    
    init(_ model: PostInfo) {
        self.init(
            id: model.id,
            text: model.text,
            imageUrl: model.imageUrl,
            lon: model.lon,
            lat: model.lat,
            likes: model.likes,
            author: RedMadRobotTestTaskAPI.UserInformation(model.author)
        )
    }
    
}
