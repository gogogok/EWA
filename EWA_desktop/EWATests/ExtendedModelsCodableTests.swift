import XCTest
@testable import EWA

final class ExtendedModelsCodableTests: XCTestCase {
    private let sampleUser = UserResponse(
        id: "user-1",
        name: "Dasha",
        email: "dasha@example.com",
        iconName: "fox"
    )

    func testAlarmResponseEncodesAndDecodes() throws {
        let alarm = AlarmResponse(
            id: "alarm-1",
            userId: "user-1",
            description: "Wake me up",
            category: "morning",
            comment: "Call twice",
            categoryHexColor: "#9F5FFC",
            date: "16.05.2026",
            time: "07:30",
            user: sampleUser,
            countPart: 3
        )

        let data = try JSONEncoder().encode(alarm)
        let decoded = try JSONDecoder().decode(AlarmResponse.self, from: data)

        XCTAssertEqual(decoded.id, "alarm-1")
        XCTAssertEqual(decoded.description, "Wake me up")
        XCTAssertEqual(decoded.categoryHexColor, "#9F5FFC")
        XCTAssertEqual(decoded.countPart, 3)
        XCTAssertEqual(decoded.user.name, "Dasha")
    }

    func testAlarmsPageResponseDecodesEmptyPage() throws {
        let json = #"""
        {
          "content": [],
          "page": 2,
          "size": 20,
          "totalElements": 40,
          "totalPages": 2,
          "last": true
        }
        """#.data(using: .utf8)!

        let page = try JSONDecoder().decode(AlarmsPageResponse.self, from: json)

        XCTAssertTrue(page.content.isEmpty)
        XCTAssertEqual(page.page, 2)
        XCTAssertEqual(page.size, 20)
        XCTAssertEqual(page.totalElements, 40)
        XCTAssertEqual(page.totalPages, 2)
        XCTAssertTrue(page.last)
    }

    func testEventResponseEncodesAndDecodes() throws {
        let event = EventResponse(
            id: "event-1",
            userId: "user-1",
            name: "Coffee meeting",
            category: "friends",
            date: "16.05.2026",
            time: "18:00",
            place: "Warsaw",
            description: "Meet near university",
            comment: "Bring laptop",
            user: sampleUser
        )

        let data = try JSONEncoder().encode(event)
        let decoded = try JSONDecoder().decode(EventResponse.self, from: data)

        XCTAssertEqual(decoded.id, "event-1")
        XCTAssertEqual(decoded.name, "Coffee meeting")
        XCTAssertEqual(decoded.place, "Warsaw")
        XCTAssertEqual(decoded.user.email, "dasha@example.com")
    }

    func testStudyResponseDecodesNilPasswordForPublicRoom() throws {
        let json = #"""
        {
          "id": "room-2",
          "userId": "user-1",
          "name": "Public study",
          "description": "No pin",
          "category": "math",
          "type": "public",
          "user": {
            "id": "user-1",
            "name": "Dasha",
            "email": "dasha@example.com",
            "iconName": "fox"
          },
          "mediaUrl": "https://youtu.be/test",
          "password": null
        }
        """#.data(using: .utf8)!

        let room = try JSONDecoder().decode(StudyResponse.self, from: json)

        XCTAssertEqual(room.id, "room-2")
        XCTAssertEqual(room.type, "public")
        XCTAssertNil(room.password)
    }

    func testStudyRoomParticipantEncodesAndDecodesOptionalFields() throws {
        let participant = StudyRoomParticipant(
            id: nil,
            roomId: "room-1",
            userId: "user-1",
            username: "Dasha",
            iconName: nil
        )

        let data = try JSONEncoder().encode(participant)
        let decoded = try JSONDecoder().decode(StudyRoomParticipant.self, from: data)

        XCTAssertNil(decoded.id)
        XCTAssertEqual(decoded.roomId, "room-1")
        XCTAssertEqual(decoded.userId, "user-1")
        XCTAssertEqual(decoded.username, "Dasha")
        XCTAssertNil(decoded.iconName)
    }

    func testUserResponseDecodingFailsWhenRequiredFieldIsMissing() {
        let json = #"""
        {
          "id": "user-1",
          "name": "Dasha",
          "email": "dasha@example.com"
        }
        """#.data(using: .utf8)!

        XCTAssertThrowsError(try JSONDecoder().decode(UserResponse.self, from: json))
    }
}
