//
//  Codable.swift
//  RedMadRobotTestTaskAPI
//
//  Created by Дмитрий Марченков on 26.04.2021.
//

import Foundation

extension JSONEncoder {
    internal static let `default`: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }()
}

extension JSONDecoder {
    internal static let `default`: JSONDecoder = {
        let decoder = JSONDecoder()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        decoder.dateDecodingStrategy = .formatted(formatter)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}
