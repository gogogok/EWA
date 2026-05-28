import XCTest
@testable import EWA

final class PageResponseEdgeCaseTests: XCTestCase {
    func testEventsPageResponseDecodesEmptyLastPage() throws {
        let json = #"""
        {
          "content": [],
          "page": 3,
          "size": 20,
          "totalElements": 60,
          "totalPages": 4,
          "last": true
        }
        """#.data(using: .utf8)!

        let page = try JSONDecoder().decode(EventsPageResponse.self, from: json)

        XCTAssertTrue(page.content.isEmpty)
        XCTAssertEqual(page.page, 3)
        XCTAssertTrue(page.last)
    }

    func testAlarmsPageResponseDecodesEmptyMiddlePage() throws {
        let json = #"""
        {
          "content": [],
          "page": 1,
          "size": 20,
          "totalElements": 50,
          "totalPages": 3,
          "last": false
        }
        """#.data(using: .utf8)!

        let page = try JSONDecoder().decode(AlarmsPageResponse.self, from: json)

        XCTAssertTrue(page.content.isEmpty)
        XCTAssertEqual(page.totalPages, 3)
        XCTAssertFalse(page.last)
    }

    func testStudyRoomPageResponseDecodesEmptyFirstPage() throws {
        let json = #"""
        {
          "content": [],
          "page": 0,
          "size": 20,
          "totalElements": 0,
          "totalPages": 0,
          "last": true
        }
        """#.data(using: .utf8)!

        let page = try JSONDecoder().decode(StudyRoomPageResponse.self, from: json)

        XCTAssertEqual(page.page, 0)
        XCTAssertEqual(page.totalElements, 0)
        XCTAssertTrue(page.last)
    }
}
