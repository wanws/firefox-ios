/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import XCTest

class DisplaySettingTests: BaseTestCase {


    func testDisplaySettingsDefault() {
        navigator.goto(DisplaySettings)
        waitforExistence(app.navigationBars["Display"])
        XCTAssertTrue(app.tables["DisplayTheme.Setting.Options"].exists)
        let switchValue = app.switches["DisplaySwitchValue"].value!
        XCTAssertEqual(switchValue as! String, "0")
        XCTAssertTrue(app.tables.cells.staticTexts["Light"].exists)
        XCTAssertTrue(app.tables.cells.staticTexts["Dark"].exists)
    }

    func testChangeSwitchAutomatically() {
        navigator.goto(DisplaySettings)
        waitforExistence(app.switches["Automatically, Switch automatically based on screen brightness"])
        navigator.performAction(Action.SelectAutomatically)
        waitforExistence(app.sliders["0%"])
        XCTAssertFalse(app.tables.cells.staticTexts["Dark"].exists)

        // Going back to Settings and Display settings keeps the value
        navigator.goto(SettingsScreen)
        navigator.goto(DisplaySettings)
        waitforExistence(app.switches["DisplaySwitchValue"])
        let switchValue = app.switches["DisplaySwitchValue"].value!
        XCTAssertEqual(switchValue as! String, "1")
        XCTAssertFalse(app.tables.cells.staticTexts["Dark"].exists)

        // Unselect the Automatic mode
        navigator.performAction(Action.SelectAutomatically)
        waitforExistence(app.tables.cells.staticTexts["Light"])
        XCTAssertTrue(app.tables.cells.staticTexts["Dark"].exists)
        // Needed so that the change is applied when closing the app for next test
        navigator.goto(SettingsScreen)
        app.buttons["Done"].tap()
    }

    func testChangeMode() {
        // From XCUI there is now way to check the Mode, but at least we test it can be changed
        if iPad() {
        navigator.goto(SettingsScreen)
        }
        navigator.performAction(Action.SelectDarkMode)
        navigator.goto(SettingsScreen)
        navigator.performAction(Action.SelectLightMode)
    }
}
