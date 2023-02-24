//
//  LeagueMobileChallengeTests.swift
//  LeagueMobileChallengeTests
//
//  Created by Kelvin Lau on 2019-01-09.
//  Copyright © 2019 Kelvin Lau. All rights reserved.
//

import XCTest
@testable import LeagueMobileChallenge

class LeagueMobileChallengeTests: XCTestCase {
    
    var viewController: PostsViewController = PostsViewController()
    var tableView: UITableView!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "PostsViewController") as! PostsViewController
        // Load the view hierarchy
        viewController.loadViewIfNeeded()
        tableView = viewController.postsTableView
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        viewController = nil
        tableView = nil
        super.tearDown()
    }
    
    func testThatViewLoads()
    {
        XCTAssertNotNil(self.viewController.view, "View not initiated properly");
    }
    
    func testThatTableViewLoads()
    {
        XCTAssertNotNil(self.viewController.postsTableView, "TableView not initiated")
    }
    
    func testUserTokenApiResponse() {
        let e = expectation(description: "Alamofire")
        viewController.fetchAPIData()
        
        debugPrint("----> Unit Test Login Data \(self.viewController.infoMergedData.description)")
        let resultString = self.viewController.infoMergedData.description
        let expectedString = "[]"
        XCTAssertEqual(resultString, expectedString)
        e.fulfill()
        waitForExpectations(timeout: 5.0, handler: nil)
        }
    
    func testNumberOfRowsInSection() {
            // Given
        let infoMergedData = [Info.init(id: 1, username: "Test", avatar: "jhjhjh", title: "ggghg", body: "hgjhgh")]
            viewController.infoMergedData = infoMergedData

            // When
            let numberOfRows = viewController.tableView(tableView, numberOfRowsInSection: 0)

            // Then
            XCTAssertEqual(numberOfRows, infoMergedData.count, "Number of rows in section should match the count of infoMergedData array")
        }

}
