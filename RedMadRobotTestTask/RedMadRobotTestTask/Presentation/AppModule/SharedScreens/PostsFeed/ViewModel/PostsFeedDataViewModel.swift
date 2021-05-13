//
//  PostsFeedRequestViewModel.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 08.05.2021.
//

import UIKit

protocol PostsFeedRequestViewModelProtocol: AnyObject {
    init(feedService: FeedServiceProtocol)
    func getPosts(completion: @escaping (Result<Void, Error>) -> Void)
}
