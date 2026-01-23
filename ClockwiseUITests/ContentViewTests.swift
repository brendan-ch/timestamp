//
//  ContentViewTests.swift
//  Clockwise
//
//  Created by Brendan Chen on 2026.01.16.
//

import XCTest

final class ContentViewTests: ClockwiseBaseUITests {
    func testChangingModeChangesTimer() throws {
        appendDefaultTimerLaunchArguments()
        launchAndOpenMenuBarWindow()

        app.radioButtons["Break"].firstMatch.click()
        XCTAssert(app.staticTexts["05:00"].waitForExistence(timeout: 5))
        app.radioButtons["Focus"].firstMatch.click()
        XCTAssert(app.staticTexts["25:00"].waitForExistence(timeout: 5))
    }
    
    func testCannotChangeModeDuringTimerRunning() throws {
        launchAndOpenMenuBarWindow()

        app.buttons["Start"].firstMatch.click()
        XCTAssert(app.radioButtons["Break"].waitForNonExistence(timeout: 5))
        XCTAssert(app.radioButtons["Focus"].waitForNonExistence(timeout: 5))
    }
    
    func testGrantNotificationPermissionInCalloutAsksForPermission() throws {
        resetNotificationPermissions()
        
        app.launchArguments += ["-hideGrantNotificationPermissionCallout", "0"]
        launchAndOpenMenuBarWindow()
        
        app.buttons["Grant permission"].firstMatch.click()
        
        app.menuButtons["Options"].firstMatch.click()
        app.menuItems["Settings"].firstMatch.click()
        
        // Check whether app shows up in system notification settings
        // The CI runner doesn't show notifications on the top right
        app.buttons["Open system notification settings"].firstMatch.click()
        let systempreferencesApp = XCUIApplication(bundleIdentifier: "com.apple.systempreferences")
        systempreferencesApp.activate()
        XCTAssert(systempreferencesApp.buttons["Clockwise, Off"].waitForExistence(timeout: 5))
    }
    
    func testDismissNotificationPermissionCalloutDismissesCallout() throws {
        app.launchArguments += ["-hideGrantNotificationPermissionCallout", "0"]
        launchAndOpenMenuBarWindow()
        
        app.buttons["Dismiss"].firstMatch.click()
        
        XCTAssert(app.staticTexts["Grant notification permission to receive timer notifications."].waitForNonExistence(timeout: 5))
    }
}
