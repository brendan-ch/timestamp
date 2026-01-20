//
//  ClockwiseUITests.swift
//  ClockwiseUITests
//
//  Created by Brendan Chen on 2026.01.14.
//

import XCTest

@MainActor
class ClockwiseBaseUITests: XCTestCase {
    var app: XCUIApplication = XCUIApplication()
    
    // MARK: setup
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app = XCUIApplication()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}
