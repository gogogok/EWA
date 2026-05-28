import XCTest
import UIKit
@testable import EWA

final class CellsConfigurationTests: XCTestCase {
    func testParticipantCellConfigureWithParticipantShowsUsername() {
        let cell = ParticipantCell(frame: CGRect(x: 0, y: 0, width: 300, height: 80))
        let participant = StudyRoomParticipant(
            id: "part-1",
            roomId: "room-1",
            userId: "user-1",
            username: "Dasha",
            iconName: nil
        )

        cell.configure(participant: participant)

        XCTAssertTrue(cell.contentView.containsLabelText("Dasha"))
    }

    func testParticipantCellConfigureWithUserShowsName() {
        let cell = ParticipantCell(frame: CGRect(x: 0, y: 0, width: 300, height: 80))
        let user = UserResponse(id: "user-1", name: "Anna", email: "anna@example.com", iconName: "fox")

        cell.configureWithUser(user: user)

        XCTAssertTrue(cell.contentView.containsLabelText("Anna"))
    }

    func testChatMessageCellConfigureMineShowsYouAndRightAlignment() throws {
        let cell = ChatMessageCell(style: .default, reuseIdentifier: ChatMessageCell.reuseId)
        let message = ChatMessage(
            roomId: "room-1",
            userId: "user-1",
            username: "Dasha",
            text: "Hello from me",
            createdAt: nil
        )

        cell.configure(with: message, isMine: true)

        let labels = cell.contentView.allSubviewsRecursive(of: UILabel.self)
        let nameLabel = try XCTUnwrap(labels.first { $0.text == "Вы" })
        let messageLabel = try XCTUnwrap(labels.first { $0.text == "Hello from me" })
        XCTAssertEqual(nameLabel.textAlignment, .right)
        XCTAssertEqual(messageLabel.textAlignment, .right)
    }

    func testChatMessageCellConfigureOtherUserShowsUsernameAndLeftAlignment() throws {
        let cell = ChatMessageCell(style: .default, reuseIdentifier: ChatMessageCell.reuseId)
        let message = ChatMessage(
            roomId: "room-1",
            userId: "user-2",
            username: "Kirill",
            text: "Hello from other user",
            createdAt: nil
        )

        cell.configure(with: message, isMine: false)

        let labels = cell.contentView.allSubviewsRecursive(of: UILabel.self)
        let nameLabel = try XCTUnwrap(labels.first { $0.text == "Kirill" })
        let messageLabel = try XCTUnwrap(labels.first { $0.text == "Hello from other user" })
        XCTAssertEqual(nameLabel.textAlignment, .left)
        XCTAssertEqual(messageLabel.textAlignment, .left)
    }
}
