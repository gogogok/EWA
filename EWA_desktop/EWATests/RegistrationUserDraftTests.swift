import XCTest
@testable import EWA

final class RegistrationUserDraftTests: XCTestCase {
    func testDraftStartsWithNilValues() {
        let draft = RegistrationUserDraft()

        XCTAssertNil(draft.id)
        XCTAssertNil(draft.name)
        XCTAssertNil(draft.email)
        XCTAssertNil(draft.iconName)
    }

    func testDraftCanStoreRegistrationValues() {
        var draft = RegistrationUserDraft()

        draft.id = "user-1"
        draft.name = "Dasha"
        draft.email = "dasha@example.com"
        draft.iconName = "fox"

        XCTAssertEqual(draft.id, "user-1")
        XCTAssertEqual(draft.name, "Dasha")
        XCTAssertEqual(draft.email, "dasha@example.com")
        XCTAssertEqual(draft.iconName, "fox")
    }
}
