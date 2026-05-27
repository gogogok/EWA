import XCTest
@testable import EWA

final class ModelsDecodingTests: XCTestCase {
    func testUserResponseDecodesFromJSON() throws {
        let json = #"""
        {
          "id": "user-1",
          "name": "Dasha",
          "email": "dasha@example.com",
          "iconName": "fox"
        }
        """#.data(using: .utf8)!

        let user = try JSONDecoder().decode(UserResponse.self, from: json)

        XCTAssertEqual(user.id, "user-1")
        XCTAssertEqual(user.name, "Dasha")
        XCTAssertEqual(user.email, "dasha@example.com")
        XCTAssertEqual(user.iconName, "fox")
    }

    func testStudyRoomPageResponseDecodesFromJSON() throws {
        let json = #"""
        {
          "content": [
            {
              "id": "room-1",
              "userId": "user-1",
              "name": "Math study",
              "description": "Prepare for exam",
              "category": "study",
              "type": "private",
              "user": {
                "id": "user-1",
                "name": "Dasha",
                "email": "dasha@example.com",
                "iconName": "fox"
              },
              "mediaUrl": "https://youtu.be/test",
              "password": "1234"
            }
          ],
          "page": 0,
          "size": 20,
          "totalElements": 1,
          "totalPages": 1,
          "last": true
        }
        """#.data(using: .utf8)!

        let page = try JSONDecoder().decode(StudyRoomPageResponse.self, from: json)

        XCTAssertEqual(page.content.count, 1)
        XCTAssertEqual(page.content.first?.id, "room-1")
        XCTAssertEqual(page.content.first?.type, "private")
        XCTAssertEqual(page.content.first?.password, "1234")
        XCTAssertTrue(page.last)
    }

    func testStudyResponseEncodesMediaUrlAndOptionalPassword() throws {
        let room = StudyResponse(
            id: "room-1",
            userId: "user-1",
            name: "Public room",
            description: "No password room",
            category: "study",
            type: "public",
            user: UserResponse(id: "user-1", name: "Dasha", email: "dasha@example.com", iconName: "fox"),
            mediaUrl: "https://youtu.be/test",
            password: nil
        )

        let data = try JSONEncoder().encode(room)
        let object = try JSONSerialization.jsonObject(with: data) as? [String: Any]

        XCTAssertEqual(object?["mediaUrl"] as? String, "https://youtu.be/test")
        XCTAssertNil(object?["password"])
    }

    func testEventsPageResponseDecodesFromJSON() throws {
        let json = #"""
        {
          "content": [
            {
              "id": "event-1",
              "userId": "user-1",
              "name": "Walk",
              "category": "outside",
              "date": "16.05.2026",
              "time": "18:00",
              "place": "Warsaw",
              "description": "Evening walk",
              "comment": "Bring water",
              "user": {
                "id": "user-1",
                "name": "Dasha",
                "email": "dasha@example.com",
                "iconName": "fox"
              }
            }
          ],
          "page": 0,
          "size": 10,
          "totalElements": 1,
          "totalPages": 1,
          "last": true
        }
        """#.data(using: .utf8)!

        let page = try JSONDecoder().decode(EventsPageResponse.self, from: json)

        XCTAssertEqual(page.content.first?.name, "Walk")
        XCTAssertEqual(page.content.first?.place, "Warsaw")
        XCTAssertEqual(page.totalElements, 1)
    }
}
