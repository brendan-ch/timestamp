//
//  TimerTests.swift
//  Timestamp
//
//  Created by Brendan Chen on 2026.01.16.
//

import XCTest

final class TimerTests: TimestampBaseUITests {
    func testStartStopTimer() throws {
        appendDefaultTimerLaunchArguments()
        launchAndOpenMenuBarWindow()
        
        app.buttons["Start"].firstMatch.click()
        
        let currentDate = Date.now
        let expectedEndingDate = currentDate.addingTimeInterval(25 * 60)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let expectedEndingTimeString = dateFormatter.string(from: expectedEndingDate)
        
        XCTAssert(app.staticTexts["Time remaining: 25:00"].waitForNonExistence(timeout: 5))
        XCTAssert(app.staticTexts["Ending time: \(expectedEndingTimeString)"].waitForExistence(timeout: 5))
        
        app.buttons["Stop"].firstMatch.click()
        XCTAssert(app.staticTexts["Time remaining: 25:00"].waitForExistence(timeout: 5))
    }
    
    func testTimerAutomaticallyStops() throws {
        appendDefaultTimerLaunchArguments()
        app.launchArguments += ["-focusIntervalSeconds", "2"]
        app.launch()
        
        app.statusItems.firstMatch.click()
        app.buttons["Start"].firstMatch.click()
        
        // New behavior: timer automatically switches to break mode
        XCTAssert(app.staticTexts["Time remaining: 05:00"].waitForExistence(timeout: 5))
        XCTAssert(app.buttons["Start"].exists)
    }
}
