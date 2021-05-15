//
//  TestFeedCoordinator.swift
//  RedMadRobotTestTaskTests
//
//  Created by Дмитрий Марченков on 10.05.2021.
//

import XCTest

@testable import RedMadRobotTestTask

final class TestFeedCoordinator: XCTestCase {
    
    // MARK: - Properties
    
    private var feedCoordinator: FeedModuleCoordinator!
    
    // MARK: - XCTest
    
    override func setUp() {
        super.setUp()
        feedCoordinator = FeedModuleCoordinator(navigationController: UINavigationController())
    }

    override func tearDown() {
        super.tearDown()
        feedCoordinator = nil
    }
    
    // MARK: - Methods
    
    func testStartCoordinator() {
        feedCoordinator.start()
        
        let initialScreen = feedCoordinator.navigationController.topViewController
        
        XCTAssertEqual(initialScreen is FeedScreenContainerVC, true)
    }
    
    func testShowSearchFriends() {
        feedCoordinator.showSearchFriendScreen()
        
        let searchScreen = feedCoordinator.navigationController.topViewController
        
        XCTAssertEqual(searchScreen is SearchFriendsVC, true)
    }
}
