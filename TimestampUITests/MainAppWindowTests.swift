//
//  MainAppWindowTests.swift
//  Timestamp
//
//  Created by Brendan Chen on 2026.02.14.
//

import XCTest

final class MainAppWindowTests: TimestampBaseUITests {
    func testAppWindowShrinksWhenPermissionCalloutDismissed() throws {
        app.launchArguments += ["-hideGrantNotificationPermissionCallout", "0", "-openMainWindow", "1"]
        app.launch()

        let dismissButton = hittableButton("Dismiss")
        var windowsDescription = ""
        for (index, window) in app.windows.allElementsBoundByIndex.enumerated() {
            windowsDescription += "[\(index)] title=\(window.title) frame=\(window.frame) hittable=\(window.isHittable)\n"
        }
        XCTAssertNotNil(dismissButton, "no hittable Dismiss button. windows:\n\(windowsDescription)")
        
        let window = app.windows.firstMatch
        let heightBefore = window.frame.height
        
        dismissButton!.click()
        
        let shrunk = NSPredicate { _, _ in
            self.app.windows.firstMatch.frame.height < heightBefore - 1
        }
        expectation(for: shrunk, evaluatedWith: app)
        waitForExpectations(timeout: 5)
    }

    private func hittableButton(_ label: String) -> XCUIElement? {
        app.buttons.matching(NSPredicate(format: "label == %@", label)).allElementsBoundByIndex.first(where: { $0.isHittable })
    }
}
