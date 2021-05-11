//
//  FeedModuleFabric.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 10.05.2021.
//

import UIKit

protocol FeedModuleFabricProtocol {
    func createFeedScreen(
        outputDelegate: FeedScreenOutPutDelegate?
    ) -> UIViewController
    
    func createSearchFriendsScreen(
        outputDelegate: SearchFriendsOutputDelegate?
    ) -> UIViewController
}

struct FeedModuleFabric: FeedModuleFabricProtocol {
    
    public func createFeedScreen(
        outputDelegate: FeedScreenOutPutDelegate?
    ) -> UIViewController {
        return NewFeedScreenVC(outputSubscriber: outputDelegate)
    }
    
    public func createSearchFriendsScreen(
        outputDelegate: SearchFriendsOutputDelegate?
    ) -> UIViewController {
        return SearchFriendsVC(outputSubscriber: outputDelegate)
    }
    
}
