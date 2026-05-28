import XCTest
import UIKit
@testable import EWA

final class CardViewsTests: XCTestCase {
    func testAdventureCardConfigureShowsModelTextAndCallsJoinCallback() throws {
        let card = AdventureCardView(frame: CGRect(x: 0, y: 0, width: 360, height: 120))
        let model = AdventureCardView.Model(
            id: "event-1",
            title: "Board games",
            description: "Evening event",
            category: "Fun",
            dateText: "16.05 18:00",
            avatarIconName: "fox",
            buttonTitle: "Вперёд!"
        )
        var didTapJoin = false
        card.onJoinTap = { didTapJoin = true }

        card.configure(with: model)

        XCTAssertTrue(card.containsLabelText("Board games"))
        XCTAssertTrue(card.containsLabelText("Evening event"))
        XCTAssertTrue(card.containsLabelText("Fun"))
        XCTAssertTrue(card.containsLabelText("16.05 18:00"))

        let button = try XCTUnwrap(card.firstButton(withTitle: "Вперёд!"))
        button.sendActions(for: .touchUpInside)
        XCTAssertTrue(didTapJoin)
    }

    func testAdventureCardEditingModeShowsEditButton() {
        let card = AdventureCardView(frame: CGRect(x: 0, y: 0, width: 360, height: 120))

        card.isEditingMode = true

        let imageButtons = card.allSubviewsRecursive(of: UIButton.self).filter { $0.image(for: .normal) != nil }
        XCTAssertTrue(imageButtons.contains { !$0.isHidden })
    }

    func testAlarmCardConfigureShowsModelTextAndCallsJoinCallback() throws {
        let card = AlarmCardView(frame: CGRect(x: 0, y: 0, width: 360, height: 120))
        let model = AlarmCardView.Model(
            id: "alarm-1",
            description: "Wake me before exam",
            category: "Study",
            categoryHexColor: "#00D78C",
            dateText: "17.05 07:30",
            avatarIconName: "wolf",
            buttonTitle: "Разбудить!",
            count: 3
        )
        var didTapJoin = false
        card.onJoinTap = { didTapJoin = true }

        card.configure(with: model)

        XCTAssertTrue(card.containsLabelText("Wake me before exam"))
        XCTAssertTrue(card.containsLabelText("Study"))
        XCTAssertTrue(card.containsLabelText("17.05 07:30"))

        let button = try XCTUnwrap(card.firstButton(withTitle: "Разбудить!"))
        button.sendActions(for: .touchUpInside)
        XCTAssertTrue(didTapJoin)
    }

    func testStudyCardConfigurePublicRoomShowsTextAndCallsJoinCallback() throws {
        let card = StudyCardView(frame: CGRect(x: 0, y: 0, width: 360, height: 120))
        let model = StudyCardView.Model(
            id: "room-1",
            name: "Math room",
            description: "Prepare together",
            category: "Algebra",
            type: "public",
            avatarIconName: "crow",
            mediaURl: "https://youtu.be/test"
        )
        var didTapJoin = false
        card.onJoinTap = { didTapJoin = true }

        card.configure(with: model)

        XCTAssertTrue(card.containsLabelText("Math room"))
        XCTAssertTrue(card.containsLabelText("Prepare together"))
        XCTAssertTrue(card.containsLabelText("Algebra"))
        XCTAssertTrue(card.containsLabelText("public"))

        let button = try XCTUnwrap(card.firstButton(withTitle: "Вперёд"))
        button.sendActions(for: .touchUpInside)
        XCTAssertTrue(didTapJoin)
    }

    func testStudyCardPrivateRoomUsesRedBadgeColor() throws {
        let card = StudyCardView(frame: CGRect(x: 0, y: 0, width: 360, height: 120))
        card.configure(with: StudyCardView.Model(
            id: "room-2",
            name: "Private room",
            description: "PIN required",
            category: "Swift",
            type: "private",
            avatarIconName: "fox",
            mediaURl: "https://youtu.be/test"
        ))

        let typeLabel = try XCTUnwrap(card.allSubviewsRecursive(of: UILabel.self).first { $0.text == "private" })
        let expected = UIColor(hex: "#C70000")
        XCTAssertEqual(typeLabel.backgroundColor, expected)
    }
}
