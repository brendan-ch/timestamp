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
        
        app.launch()
        app.statusItems.firstMatch.click()
        
        app/*@START_MENU_TOKEN@*/.menuButtons["Options"].firstMatch/*[[".groups.menuButtons[\"Options\"].firstMatch",".menuButtons",".containing(.menuItem, identifier: \"menuAction:\").firstMatch",".containing(.menu, identifier: nil).firstMatch",".firstMatch",".menuButtons[\"Options\"].firstMatch"],[[[-1,5],[-1,1,1],[-1,0]],[[-1,4],[-1,3],[-1,2]]],[0]]@END_MENU_TOKEN@*/.click()
        app/*@START_MENU_TOKEN@*/.menuItems["Settings"]/*[[".menus.menuItems[\"Settings\"]",".menuItems[\"Settings\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.click()
        
        let checkbox = app/*@START_MENU_TOKEN@*/.checkBoxes["Open on login"]/*[[".groups.checkBoxes[\"Open on login\"]",".checkBoxes",".checkBoxes[\"Open on login\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        // See https://stackoverflow.com/questions/49822365/ios-xctests-how-to-verify-checkbox-button-is-checked-or-not
        if checkbox.value as? Int64 == 0 {
            checkbox.click()
        }
        
        app.terminate()
        app.launch()
        app.statusItems.firstMatch.click()
        
        app/*@START_MENU_TOKEN@*/.menuButtons["Options"].firstMatch/*[[".groups.menuButtons[\"Options\"].firstMatch",".menuButtons",".containing(.menuItem, identifier: \"menuAction:\").firstMatch",".containing(.menu, identifier: nil).firstMatch",".firstMatch",".menuButtons[\"Options\"].firstMatch"],[[[-1,5],[-1,1,1],[-1,0]],[[-1,4],[-1,3],[-1,2]]],[0]]@END_MENU_TOKEN@*/.click()
        app/*@START_MENU_TOKEN@*/.menuItems["Settings"]/*[[".menus.menuItems[\"Settings\"]",".menuItems[\"Settings\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.click()

        XCTAssert(app.checkBoxes["Open on login"].waitForExistence(timeout: 5))
        XCTAssert(app.checkBoxes["Open on login"].value as? Int64 == 1)
    }
}
