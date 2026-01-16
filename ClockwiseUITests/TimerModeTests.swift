//
//  TimerModeTests.swift
//  Clockwise
//
//  Created by Brendan Chen on 2026.01.16.
//

import XCTest

final class TimerModeTests: ClockwiseBaseUITests {
    @MainActor
    func testChangingModeChangesTimer() throws {
        app.launch()
        app.statusItems.firstMatch.click()
        
        app.radioButtons["Break"].firstMatch.click()
        XCTAssert(app.staticTexts["05:00"].waitForExistence(timeout: 5))
        app.radioButtons["Focus"].firstMatch.click()
        XCTAssert(app.staticTexts["25:00"].waitForExistence(timeout: 5))
    }
    
    @MainActor
    func testCannotChangeModeDuringTimerRunning() throws {
        app.launch()
        app.statusItems.firstMatch.click()
        
        app.buttons["Start"].firstMatch.click()
        XCTAssert(app.radioButtons["Break"].waitForNonExistence(timeout: 5))
        XCTAssert(app.radioButtons["Focus"].waitForNonExistence(timeout: 5))
    }
}
