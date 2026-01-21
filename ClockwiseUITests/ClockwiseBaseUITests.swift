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
    
    func launchAndOpenMenuBarWindow() {
        app.launch()
        app.statusItems.firstMatch.click()
    }
    
    func launchAndOpenSettings() {
        launchAndOpenMenuBarWindow()
        
        app.menuButtons["Options"].firstMatch.click()
        app.menuItems["Settings"].firstMatch.click()
    }
    
    func resetNotificationPermissions() {
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
        // Can take a while for the settings to show up on first launch
        let applicationNotificationsHeading = systempreferencesApp.staticTexts["Application Notifications"]
        if !applicationNotificationsHeading.waitForExistence(timeout: 20) {
            app.terminate()
            return
        }
        
        var clockwiseListItem = systempreferencesApp.buttons["Clockwise, Off"]
        
        if clockwiseListItem.waitForExistence(timeout: 2) {
            resetNotificationsForListItem(clockwiseListItem)
        }
        clockwiseListItem = systempreferencesApp.buttons["Clockwise, Sounds, Desktop"]
        if clockwiseListItem.waitForExistence(timeout: 2) {
            resetNotificationsForListItem(clockwiseListItem)
        }
        
        app.terminate()

    }
}
