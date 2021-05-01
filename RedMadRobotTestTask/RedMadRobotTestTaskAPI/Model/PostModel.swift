//
//  PostModel.swift
//  RedMadRobotTestTaskAPI
//
//  Created by Дмитрий Марченков on 28.04.2021.
//

import Foundation

public struct PostInfo: Codable {
    
    public var id: String
    public var text: String?
    public var avatarUrl: URL?
    public var lon: Float?
    public var lat: Float?
    public var likes: Int
    
    public var author: UserInformation
}
