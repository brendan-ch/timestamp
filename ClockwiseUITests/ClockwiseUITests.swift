//
//  ClockwiseUITests.swift
//  ClockwiseUITests
//
//  Created by Brendan Chen on 2026.01.14.
//

import XCTest

final class ClockwiseUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    @MainActor
    func testStartStopTimer() throws {
        let app = XCUIApplication()
        app.activate()
        app/*@START_MENU_TOKEN@*/.statusItems/*[[".menuBars.statusItems[\"Duration\"]",".statusItems",".statusItems[\"Duration\"]"],[[[-1,2],[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.firstMatch.click()
        app/*@START_MENU_TOKEN@*/.buttons["Start"]/*[[".groups.buttons[\"Start\"]",".buttons",".buttons[\"Start\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.click()
        
        XCTAssert(app.staticTexts["25:00"].waitForNonExistence(timeout: 5))
        
        app.buttons["Stop"].firstMatch.click()
        XCTAssert(app.staticTexts["25:00"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
