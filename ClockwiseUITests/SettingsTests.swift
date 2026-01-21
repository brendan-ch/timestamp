//
//  SettingsTests.swift
//  Clockwise
//
//  Created by Brendan Chen on 2026.01.19.
//

import XCTest

final class SettingsTests: ClockwiseBaseUITests {
    func testChangeOpenOnLoginSettingPersists() throws {
        // Instead of actually logging the user out/logging them back in, check whether the option stays registered after termination
        launchAndOpenSettings()
        
        let checkbox = app.checkBoxes["Open on login"]
        // See https://stackoverflow.com/questions/49822365/ios-xctests-how-to-verify-checkbox-button-is-checked-or-not
        if checkbox.value as? Int64 == 1 {
            checkbox.click()
        }
        checkbox.click()

        app.terminate()
        app.launch()
        app.statusItems.firstMatch.click()
        
        app.menuButtons["Options"].firstMatch.click()
        app.menuItems["Settings"].firstMatch.click()

        XCTAssert(app.checkBoxes["Open on login"].waitForExistence(timeout: 5))
        XCTAssert(app.checkBoxes["Open on login"].value as? Int64 == 1)
    }
    
    func testOpenNotificationSettingsOpenSystemSettings() throws {
        launchAndOpenSettings()
        
        app.buttons["Open system notification settings"].firstMatch.click()
        
        let systempreferencesApp = XCUIApplication(bundleIdentifier: "com.apple.systempreferences")
        systempreferencesApp.activate()
        let element = systempreferencesApp.staticTexts.matching(identifier: "Notifications").element(boundBy: 0)
        XCTAssert(element.waitForExistence(timeout: 5))
        
        systempreferencesApp.terminate()
    }
    
    func testGrantNotificationPermissionAsksForPermission() throws {
        resetNotificationPermissions()
        
        launchAndOpenSettings()
        app.buttons["Grant notification permission"].firstMatch.click()
        
        // Check whether app shows up in system notification settings
        // The CI runner doesn't show notifications on the top right
        app.buttons["Open system notification settings"].firstMatch.click()
        let systempreferencesApp = XCUIApplication(bundleIdentifier: "com.apple.systempreferences")
        systempreferencesApp.activate()
        XCTAssert(systempreferencesApp.buttons["Clockwise, Off"].waitForExistence(timeout: 5))
    }
}
