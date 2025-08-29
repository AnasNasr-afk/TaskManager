import XCTest

final class TaskAddUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        // If you added an in-memory mode earlier, uncomment:
        // app.launchArguments.append("UI-TESTING")
        app.launch()
    }

    // MARK: - Helpers

    private func attachHierarchy(_ name: String = "UI Hierarchy") {
        let att = XCTAttachment(string: app.debugDescription)
        att.name = name
        att.lifetime = .keepAlways
        add(att)
    }

    private func tapAddButton(file: StaticString = #file, line: UInt = #line) {
        // Try specific, then generic candidates
        let candidates: [XCUIElement] = [
            app.buttons["Add"],
            app.navigationBars.buttons["Add"],
            app.buttons["plus"],
            app.buttons["plus.circle"],
            app.buttons["plus.circle.fill"],
            app.navigationBars.element(boundBy: 0).buttons.element(boundBy: 0)
        ]

        for el in candidates where el.exists && el.isHittable {
            el.tap(); return
        }

        // Fallback: any button whose label contains add/plus
        let pred = NSPredicate(format: "label CONTAINS[c] 'add' OR label CONTAINS[c] 'plus'")
        let any = app.buttons.containing(pred).firstMatch
        if any.exists && any.isHittable { any.tap(); return }

        attachHierarchy("Could not find Add button")
        XCTFail("Add button not found", file: file, line: line)
    }

    private func enterTitle(_ text: String, file: StaticString = #file, line: UInt = #line) {
        // Try common placeholders/labels, then first text field
        let fields: [XCUIElement] = [
            app.textFields["Title"],
            app.textFields["Task Title"],
            app.textFields["Enter task"],
            app.textFields.element(boundBy: 0)
        ]
        for f in fields where f.exists {
            XCTAssertTrue(f.waitForExistence(timeout: 3), "Title field didn’t appear", file: file, line: line)
            f.tap()
            f.typeText(text)
            return
        }
        attachHierarchy("Could not find Title text field")
        XCTFail("Title text field not found", file: file, line: line)
    }

    private func tapSave(file: StaticString = #file, line: UInt = #line) {
        // Try “Save” in view or navbar; fall back to common labels
        let candidates: [XCUIElement] = [
            app.buttons["Save"].firstMatch,
            app.navigationBars.buttons["Save"],
        ]
        for el in candidates where el.exists && el.isHittable {
            el.tap(); return
        }
        let pred = NSPredicate(format: "label CONTAINS[c] 'save' OR label CONTAINS[c] 'done' OR label CONTAINS[c] 'add'")
        let any = app.buttons.containing(pred).firstMatch
        if any.exists && any.isHittable { any.tap(); return }

        attachHierarchy("Could not find Save button")
        XCTFail("Save button not found", file: file, line: line)
    }

    // MARK: - Test

    func testAddTaskViaUI() {
        // If there’s a tab bar, ensure we’re on the first tab (usually Home)
        if app.tabBars.firstMatch.exists {
            let homeBtn = app.tabBars.buttons["Home"]
            if homeBtn.exists { homeBtn.tap() }
            else { app.tabBars.buttons.element(boundBy: 0).tap() }
        }

        tapAddButton()
        enterTitle("Buy milk")
        tapSave()

        // Verify new task is visible
        let pred = NSPredicate(format: "label CONTAINS[c] %@", "Buy milk")
        let cell = app.staticTexts.containing(pred).firstMatch
        if !cell.waitForExistence(timeout: 5) {
            attachHierarchy("After save – could not find 'Buy milk'")
        }
        XCTAssertTrue(cell.exists, "Newly added task not found in the list")
    }
}

