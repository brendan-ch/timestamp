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
    
    func testSetMinutesChangesTimerDisplay() throws {
        launchAndOpenSettings()
        
        let focusTextField = app.textFields["Minutes for focus"]
        focusTextField.doubleClick()
        focusTextField.typeKey(.delete, modifierFlags: [])
        focusTextField.typeText("30")
        
        let breakTextField = app.textFields["Minutes for break"]
        breakTextField.doubleClick()
        breakTextField.typeKey(.delete, modifierFlags: [])
        breakTextField.typeText("15")
        
        app.terminate()
        launchAndOpenMenuBarWindow()
        
        XCTAssert(app.staticTexts["Time remaining: 30:00"].waitForExistence(timeout: 5))
        app.radioButtons["Break"].tap()
        XCTAssert(app.staticTexts["Time remaining: 15:00"].waitForExistence(timeout: 5))
    }
    
    func testInputInvalidMinutesDoesNotSave() throws {
        launchAndOpenSettings()
        
        let focusTextField = app.textFields["Minutes for focus"]
        let previousFocusTextFieldValue = focusTextField.value as? String
        focusTextField.doubleClick()
        focusTextField.typeKey(.delete, modifierFlags: [])
        focusTextField.typeText("abcd")

        let breakTextField = app.textFields["Minutes for break"]
        let previousBreakTextFieldValue = breakTextField.value as? String
        breakTextField.doubleClick()
        breakTextField.typeKey(.delete, modifierFlags: [])
        breakTextField.typeText("efgh")
        breakTextField.typeKey(.enter, modifierFlags: [])
        
        XCTAssert(focusTextField.value as? String == previousFocusTextFieldValue)
        XCTAssert(breakTextField.value as? String == previousBreakTextFieldValue)
    }
}
