//
//  AddPostModel.swift
//  RedMadRobotTestTaskAPI
//
//  Created by Дмитрий Марченков on 12.06.2021.
//

import Foundation

public struct AddPostModel: Codable, Equatable {
    
    public init(
        text: String?,
        imageData: Data?,
        lon: Double?,
        lat: Double?
    ) {
        self.text = text
        self.imageData = imageData
        self.lon = lon
        self.lat = lat
    }

    public var text: String?
    public var imageData: Data?
    public var lon: Double?
    public var lat: Double?
}
