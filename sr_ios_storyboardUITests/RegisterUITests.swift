import XCTest

class RegisterUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRegister() throws {
        let app = XCUIApplication()
        app.launchEnvironment = ["testcase": "register"]
        app.launch()
        app.buttons["registerTab"].tap()
        let register = app.buttons["registerButton"]
        register.tap()
        XCTAssertEqual(app.staticTexts["error"].label, "Username is required")
        let username =  app.textFields["Username"]
        username.tap()
        username.typeText("username1")
        app.staticTexts["error"].tap()
        register.tap()
        XCTAssertEqual(app.staticTexts["error"].label, "Password is required")
        let password =  app.textFields["Password"]
        password.tap()
        password.typeText("password1")
        app.staticTexts["error"].tap()
        register.tap()
        XCTAssertEqual(app.staticTexts["error"].label, "Repassword is required")
        let repassword =  app.textFields["Repassword"]
        repassword.tap()
        repassword.typeText("password")
        app.staticTexts["error"].tap()
        register.tap()
        XCTAssertEqual(app.staticTexts["error"].label, "Repassword is not matching")
        repassword.tap()
        repassword.typeText("1")
        app.staticTexts["error"].tap()
        register.tap()
        XCTAssertTrue(app.tables["entryList"].exists)
        XCTAssertEqual(app.cells.count, 2)
    }

    func testRegisterError() throws {
        let app = XCUIApplication()
        app.launchEnvironment = ["testcase": "register_error"]
        app.launch()
        app.buttons["registerTab"].tap()
        let username =  app.textFields["Username"]
        username.tap()
        username.typeText("username1")
        let password =  app.textFields["Password"]
        password.tap()
        password.typeText("password1")
        let repassword =  app.textFields["Repassword"]
        repassword.tap()
        repassword.typeText("password1")
        app.buttons["registerButton"].tap()
        XCTAssertEqual(app.alerts.staticTexts.element(boundBy: 0).label, "Register error")
    }
    
    func testRegisterFail() throws {
        let app = XCUIApplication()
        app.launchEnvironment = ["testcase": "register_fail"]
        app.launch()
        app.buttons["registerTab"].tap()
        let username =  app.textFields["Username"]
        username.tap()
        username.typeText("username1")
        let password =  app.textFields["Password"]
        password.tap()
        password.typeText("password1")
        let repassword =  app.textFields["Repassword"]
        repassword.tap()
        repassword.typeText("password1")
        app.buttons["registerButton"].tap()
        XCTAssertEqual(app.alerts.staticTexts.element(boundBy: 0).label, "Register fail")
    }
}
