import XCTest

class EntryUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEntryList() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-token", "token1"]
        app.launchEnvironment = ["testcase": "entry_list"]
        app.launch()
        XCTAssertTrue(app.tables["entryList"].exists)
        XCTAssertEqual(app.cells.count, 2)
    }

    func testEntryDetail() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-token", "token1"]
        app.launchEnvironment = ["testcase": "entry_list"]
        app.launch()
        XCTAssertTrue(app.tables["entryList"].exists)
        XCTAssertEqual(app.cells.count, 2)
        app.cells.element(boundBy: 1).tap()
        XCTAssertTrue(app.tables["entryDetail"].exists)
        XCTAssertEqual(app.cells.count, 2)
    }
    
    func testEntryEdit() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-token", "token1"]
        app.launchEnvironment = ["testcase": "entry_edit"]
        app.launch()
        app.cells.element(boundBy: 1).tap()
        let editEntry = app.buttons["editEntry"]
        editEntry.tap()
        app.buttons["cancelEdit"].tap()
        editEntry.tap()
        let editTile = app.textFields["editTitle"]
        editTile.tap()
        editTile.typeText("edit")
        editEntry.tap()
        DispatchQueue.main.async {
            XCTAssertTrue(editEntry.isEnabled)
        }
    }
    
    func testEntryEditFail() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-token", "token1"]
        app.launchEnvironment = ["testcase": "entry_edit_fail"]
        app.launch()
        app.cells.element(boundBy: 1).tap()
        let editEntry = app.buttons["editEntry"]
        editEntry.tap()
        let editTile = app.textFields["editTitle"]
        editTile.tap()
        editTile.typeText("edit")
        editEntry.tap()
        XCTAssertTrue(app.otherElements["login"].exists)
    }
    
    func testEntryAdd() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-token", "token1"]
        app.launchEnvironment = ["testcase": "entry_add"]
        app.launch()
        app.buttons["addEntry"].tap()
        let editTile = app.textFields["editTitle"]
        editTile.tap()
        editTile.typeText("entrytitleadd")
        let editContent = app.textViews["editContent"]
        editContent.tap()
        editContent.typeText("entrycontentadd")
        app.buttons["editEntry"].tap()
        XCTAssertEqual(app.tables.count, 1)
    }
    
    func testEntryAddFail() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-token", "token1"]
        app.launchEnvironment = ["testcase": "entry_add_fail"]
        app.launch()
        app.buttons["addEntry"].tap()
        let editTile = app.textFields["editTitle"]
        editTile.tap()
        editTile.typeText("entrytitleadd")
        let editContent = app.textViews["editContent"]
        editContent.tap()
        editContent.typeText("entrycontentadd")
        app.buttons["editEntry"].tap()
        XCTAssertTrue(app.otherElements["login"].exists)
    }
}
