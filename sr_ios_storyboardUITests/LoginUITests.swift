import XCTest

class LoginUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNoLogin() throws {
        let app = XCUIApplication()
        app.launchEnvironment = ["testcase": "login"]
        app.launch()
        XCTAssertFalse(app.tables["entryList"].exists)
        XCTAssertTrue(app.otherElements["login"].exists)
    }
    
    func testLogin() throws {
        let app = XCUIApplication()
        app.launchEnvironment = ["testcase": "login"]
        app.launch()
        let username = app.textFields["Username"]
        username.tap()
        username.typeText("username1")
        let password = app.textFields["Password"]
        password.tap()
        password.typeText("password1")
        app.buttons["loginButton"].tap()
        XCTAssertTrue(app.tables["entryList"].exists)
        XCTAssertFalse(app.otherElements["login"].exists)
        XCTAssertEqual(app.cells.count, 2)
    }
    
    func testLoginFail() throws {
        let app = XCUIApplication()
        app.launchEnvironment = ["testcase": "login_error"]
        app.launch()
        let username = app.textFields["Username"]
        username.tap()
        username.typeText("username1")
        let password = app.textFields["Password"]
        password.tap()
        password.typeText("password1")
        app.buttons["Login"].tap()
        XCTAssertEqual(app.alerts.count, 1)
    }
    
    func testLoginError() throws {
        let app = XCUIApplication()
        app.launchEnvironment = ["testcase": "login_fail"]
        app.launch()
        let username = app.textFields["Username"]
        username.tap()
        username.typeText("username1")
        let password = app.textFields["Password"]
        password.tap()
        password.typeText("password1")
        app.buttons["Login"].tap()
        XCTAssertEqual(app.alerts.count, 1)
    }
}
