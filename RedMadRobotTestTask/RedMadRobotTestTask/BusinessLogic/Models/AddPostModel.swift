//
//  AddPostModel.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 12.06.2021.
//

import Foundation

import RedMadRobotTestTaskAPI

/// Модель для добавления нового поста
public struct AddPostModel: Codable, Equatable {
    
    public var text: String?
    public var imageData: Data?
    public var lon: Double?
    public var lat: Double?
}

// MARK: - Мапперы для связывания структур между таргетами

extension AddPostModel {
    
    init(_ model: RedMadRobotTestTaskAPI.AddPostModel) {
        text = model.text
        imageData = model.imageData
        lon = model.lon
        lat = model.lat
    }
    
}

extension RedMadRobotTestTaskAPI.AddPostModel {
    
    init(_ model: AddPostModel) {
        self.init(
            text: model.text,
            imageData: model.imageData,
            lon: model.lon,
            lat: model.lat
        )
    }
    
}
