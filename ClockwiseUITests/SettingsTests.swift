//
//  SettingsTests.swift
//  Clockwise
//
//  Created by Brendan Chen on 2026.01.19.
//

import XCTest

final class SettingsTests: ClockwiseBaseUITests {
    private func launchAndOpenSettings() {
        app.launch()
        app.statusItems.firstMatch.click()
        
        app.menuButtons["Options"].firstMatch.click()
        app.menuItems["Settings"].firstMatch.click()
    }
    
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
    }
    
    func testGrantNotificationPermissionAsksForPermission() throws {
        let systempreferencesApp = XCUIApplication(bundleIdentifier: "com.apple.systempreferences")
        func resetNotificationsForListItem(_ item: XCUIElement) {
            item.firstMatch.rightClick()
            systempreferencesApp.menuItems["Reset Notifications…"].firstMatch.click()
            systempreferencesApp.sheets.buttons["Reset Notifications"].firstMatch.click()
        }
        
        launchAndOpenSettings()
        
        app.buttons["Open system notification settings"].firstMatch.click()
        
        // If the app has previously requested to send notifications, their choice will be "remembered"
        // This code resets that state
        systempreferencesApp.activate()
        var clockwiseListItem = systempreferencesApp.buttons["Clockwise, Sounds, Desktop"]
        if clockwiseListItem.waitForExistence(timeout: 2) {
            resetNotificationsForListItem(clockwiseListItem)
        }
        clockwiseListItem = systempreferencesApp.buttons["Clockwise, Off"]
        if clockwiseListItem.waitForExistence(timeout: 2) {
            resetNotificationsForListItem(clockwiseListItem)
        }

        app.terminate()
        launchAndOpenSettings()
        app.buttons["Grant notification permission"].firstMatch.click()
        
        let notificationcenteruiApp = XCUIApplication(bundleIdentifier: "com.apple.notificationcenterui")
        notificationcenteruiApp.activate()
        XCTAssert(notificationcenteruiApp.staticTexts["“Clockwise” Notifications"].firstMatch.waitForExistence(timeout: 5))
    }
}
