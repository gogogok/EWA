import XCTest
@testable import EWA

final class ChatAndVideoModelsTests: XCTestCase {
    func testChatMessageEncodesAndDecodesWithCreatedAt() throws {
        let message = ChatMessage(
            roomId: "room-1",
            userId: "user-1",
            username: "Dasha",
            text: "Hello!",
            createdAt: "2026-05-16T12:00:00Z"
        )

        let data = try JSONEncoder().encode(message)
        let decoded = try JSONDecoder().decode(ChatMessage.self, from: data)

        XCTAssertEqual(decoded.roomId, "room-1")
        XCTAssertEqual(decoded.userId, "user-1")
        XCTAssertEqual(decoded.username, "Dasha")
        XCTAssertEqual(decoded.text, "Hello!")
        XCTAssertEqual(decoded.createdAt, "2026-05-16T12:00:00Z")
    }

    func testChatMessageEncodesAndDecodesNilCreatedAt() throws {
        let message = ChatMessage(
            roomId: "room-1",
            userId: "user-1",
            username: "Dasha",
            text: "No date yet",
            createdAt: nil
        )

        let data = try JSONEncoder().encode(message)
        let decoded = try JSONDecoder().decode(ChatMessage.self, from: data)

        XCTAssertNil(decoded.createdAt)
        XCTAssertEqual(decoded.text, "No date yet")
    }

    func testVideoSyncActionRawValues() {
        XCTAssertEqual(VideoSyncAction.play.rawValue, "play")
        XCTAssertEqual(VideoSyncAction.pause.rawValue, "pause")
        XCTAssertEqual(VideoSyncAction.seek.rawValue, "seek")
    }

    func testVideoSyncEventEncodesAndDecodes() throws {
        let event = VideoSyncEvent(
            roomId: "room-1",
            userId: "user-1",
            action: .seek,
            currentTime: 42.5,
            sentAt: 1_789_000_000
        )

        let data = try JSONEncoder().encode(event)
        let decoded = try JSONDecoder().decode(VideoSyncEvent.self, from: data)

        XCTAssertEqual(decoded.roomId, "room-1")
        XCTAssertEqual(decoded.userId, "user-1")
        XCTAssertEqual(decoded.action, .seek)
        XCTAssertEqual(decoded.currentTime, 42.5)
        XCTAssertEqual(decoded.sentAt, 1_789_000_000)
    }

    func testVideoSyncEventDecodesFromBackendLikeJSON() throws {
        let json = #"""
        {
          "roomId": "room-1",
          "userId": "user-1",
          "action": "pause",
          "currentTime": 15.75,
          "sentAt": 1789000000
        }
        """#.data(using: .utf8)!

        let event = try JSONDecoder().decode(VideoSyncEvent.self, from: json)

        XCTAssertEqual(event.action, .pause)
        XCTAssertEqual(event.currentTime, 15.75)
    }
}
