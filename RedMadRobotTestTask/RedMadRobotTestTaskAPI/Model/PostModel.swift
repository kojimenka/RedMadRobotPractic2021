//
//  PostModel.swift
//  RedMadRobotTestTaskAPI
//
//  Created by Дмитрий Марченков on 28.04.2021.
//

import Foundation

public struct PostInfo: Codable, Equatable {
    
    public init(
        id: String,
        text: String?,
        imageUrl: URL?,
        lon: Float?,
        lat: Float?,
        likes: Int,
        author: UserInformation
    ) {
        
        self.id = id
        self.text = text
        self.imageUrl = imageUrl
        self.lon = lon
        self.lat = lat
        self.likes = likes
        self.author = author
    }
    
    public var id: String
    public var text: String?
    public var imageUrl: URL?
    public var lon: Float?
    public var lat: Float?
    public var likes: Int
    
    public var author: UserInformation
}
