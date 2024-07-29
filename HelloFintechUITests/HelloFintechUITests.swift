//
//  HelloFintechUITests.swift
//  HelloFintechUITests
//
//  Created by 雲端開發部-廖彥勛 on 2024/7/22.
//

import XCTest
@testable import HelloFintech

final class HelloFintechUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testViewControllerInitialization() {
        let emptyButtonElement = app.buttons["emptyButton"]
        XCTAssertTrue(emptyButtonElement.exists)
        
        let onlyFriendButtonElement = app.buttons["onlyFriendButton"]
        XCTAssertTrue(onlyFriendButtonElement.exists)
        
        let fullButtonElement = app.buttons["fullButton"]
        XCTAssertTrue(fullButtonElement.exists)

    }
    
    func testEmptyButtonTap() {
        let emptyButtonElement = app.buttons["emptyButton"]
        XCTAssertTrue(emptyButtonElement.exists)
    
        let friendListEmptyViewElement = app.otherElements["FriendListEmptyView"]
        let exists = NSPredicate(format: "exists == 1")
        
        emptyButtonElement.tap()
        
        let expectation = expectation(for: exists, evaluatedWith: friendListEmptyViewElement)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertTrue(friendListEmptyViewElement.exists)
        expectation.fulfill()
    }
    
    func testOnlyButtonTypingWithData() {
        let onlyFriendButtonElement = app.buttons["onlyFriendButton"]
        XCTAssertTrue(onlyFriendButtonElement.exists)
        
        let tableView = app.tables["tableView"]
        let friendListViewElement = app.otherElements["FriendListView"]
        let exists = NSPredicate(format: "exists == 1")
        
        onlyFriendButtonElement.tap()
        
        let firstTableCell = tableView.cells.firstMatch
        let expectation = expectation(for: exists, evaluatedWith: firstTableCell)
        waitForExpectations(timeout: 10, handler: nil)

        XCTAssertTrue(firstTableCell.exists, "cell 0 is not on the table")
        XCTAssertTrue(friendListViewElement.exists)
        expectation.fulfill()
        
        firstTableCell.tap()
    }
   
    func testFullButtonTypingWithData() {

        let fullButtonElement = app.buttons["fullButton"]
        XCTAssertTrue(fullButtonElement.exists)
        
        let tableView = app.tables["tableView"]
        let friendListViewElement = app.otherElements["FriendListView"]
        let exists = NSPredicate(format: "exists == 1")
        
        fullButtonElement.tap()
        
        // wait for data to load
        let firstTableCell = tableView.cells.firstMatch
        let expectation = expectation(for: exists, evaluatedWith: firstTableCell)
        waitForExpectations(timeout: 10, handler: nil)

        XCTAssertTrue(firstTableCell.exists, "cell 0 is not on the table")
        XCTAssertTrue(friendListViewElement.exists)
        expectation.fulfill()
        
        firstTableCell.tap()
    }
    
    func testSearchButton() {
        let fullButtonElement = app.buttons["fullButton"]
        XCTAssertTrue(fullButtonElement.exists)
        
        let tableView = app.tables["tableView"]
        let exists = NSPredicate(format: "exists == 1")
        
        fullButtonElement.tap()
        
        let firstTableCell = tableView.cells.firstMatch
        let expectation = expectation(for: exists, evaluatedWith: firstTableCell)
        waitForExpectations(timeout: 10, handler: nil)

        XCTAssertTrue(firstTableCell.exists, "cell 0 is not on the table")
        expectation.fulfill()

        let searchBarElement = tableView.otherElements["tableHeaderSearchBar"]
        XCTAssertTrue(searchBarElement.exists)

        // 2: get the last cell element
        let cellCount = tableView.cells.count
        let lastTableCell = tableView.cells.allElementsBoundByIndex[cellCount-1]
        
        // 3: scroll to bottom
        while !lastTableCell.isHittable {
            tableView.swipeUp()
        }
        XCTAssertTrue(lastTableCell.isHittable, "Not able to scroll to the end of the Table")
        
        // 4: scroll back to the top
        while !firstTableCell.isHittable {
            tableView.swipeDown()
        }
        XCTAssertTrue(firstTableCell.isHittable, "Not able to scroll to the beginning of the Table")
    }
}
