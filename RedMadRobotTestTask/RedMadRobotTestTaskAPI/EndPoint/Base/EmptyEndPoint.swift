//
//  EmptyEndPoint.swift
//  RedMadRobotTestTaskAPI
//
//  Created by Дмитрий Марченков on 26.04.2021.
//

import Apexy

/// Empty Body Request Enpoint.
protocol EmptyEndpoint: Endpoint, URLRequestBuildable where Content == Void {}

extension EmptyEndpoint {

    public func content(from response: URLResponse?, with body: Data) throws {
        try ResponseValidator.validate(response, with: body)
    }
}
