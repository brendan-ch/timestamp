//
//  TimerTests.swift
//  Clockwise
//
//  Created by Brendan Chen on 2026.01.16.
//

import XCTest

final class TimerTests: ClockwiseBaseUITests {
    func testStartStopTimer() throws {
        app.launch()
        app/*@START_MENU_TOKEN@*/.statusItems/*[[".menuBars.statusItems[\"Duration\"]",".statusItems",".statusItems[\"Duration\"]"],[[[-1,2],[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.firstMatch.click()
        app/*@START_MENU_TOKEN@*/.buttons["Start"]/*[[".groups.buttons[\"Start\"]",".buttons",".buttons[\"Start\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.click()
        
        XCTAssert(app.staticTexts["25:00"].waitForNonExistence(timeout: 5))
        
        app.buttons["Stop"].firstMatch.click()
        XCTAssert(app.staticTexts["25:00"].waitForExistence(timeout: 5))
    }
    
    func testTimerAutomaticallyStops() throws {
        app.launchArguments += ["-focusIntervalSeconds", "2"]
        app.launch()
        
        app/*@START_MENU_TOKEN@*/.statusItems/*[[".menuBars.statusItems[\"Duration\"]",".statusItems",".statusItems[\"Duration\"]"],[[[-1,2],[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.firstMatch.click()
        app.buttons["Start"].firstMatch.click()
        XCTAssert(app.staticTexts["00:02"].waitForExistence(timeout: 5))
        XCTAssert(app.buttons["Start"].exists)
    }
}
