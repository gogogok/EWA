import XCTest
import UIKit
@testable import EWA

final class CustomViewsBehaviorTests: XCTestCase {
    func testProfileAvatarViewStoresIconNameAndIdentifier() {
        let avatar = ProfileAvatarView(iconName: "fox")

        XCTAssertEqual(avatar.iconName, "fox")
        XCTAssertEqual(avatar.accessibilityIdentifier, "fox")
        XCTAssertFalse(avatar.needEdition)
    }

    func testProfileAvatarViewSelectionChangesBorderWidth() {
        let avatar = ProfileAvatarView(iconName: "wolf")

        UIView.setAnimationsEnabled(false)
        avatar.setSelected(true)
        XCTAssertEqual(avatar.layer.borderWidth, 2)
        XCTAssertNotEqual(avatar.transform, .identity)

        avatar.setSelected(false)
        XCTAssertEqual(avatar.layer.borderWidth, 0)
        XCTAssertEqual(avatar.transform, .identity)
        UIView.setAnimationsEnabled(true)
    }

    func testColorPickerSelectColorUpdatesSelectedHex() {
        let picker = ColorPickerStackView(frame: CGRect(x: 0, y: 0, width: 300, height: 100))

        picker.selectColor(name: "#F38143")

        XCTAssertEqual(picker.selectedColorHex, "#F38143")
    }

    func testColorPickerIgnoresUnknownColor() {
        let picker = ColorPickerStackView(frame: CGRect(x: 0, y: 0, width: 300, height: 100))

        picker.selectColor(name: "#F38143")
        picker.selectColor(name: "#UNKNOWN")

        XCTAssertEqual(picker.selectedColorHex, "#F38143")
    }

    func testAdaptiveGridCreatesExpectedRows() {
        let grid = AdaptiveGridStackView(columns: 2, spacing: 8)
        let views = [UIView(), UIView(), UIView(), UIView(), UIView()]

        grid.setItems(views)

        XCTAssertEqual(grid.arrangedSubviews.count, 3)
        XCTAssertEqual((grid.arrangedSubviews[0] as? UIStackView)?.arrangedSubviews.count, 2)
        XCTAssertEqual((grid.arrangedSubviews[1] as? UIStackView)?.arrangedSubviews.count, 2)
        XCTAssertEqual((grid.arrangedSubviews[2] as? UIStackView)?.arrangedSubviews.count, 1)
    }

    func testAdaptiveGridClearsOldRowsBeforeSettingNewItems() {
        let grid = AdaptiveGridStackView(columns: 3, spacing: 8)

        grid.setItems([UIView(), UIView(), UIView(), UIView()])
        XCTAssertEqual(grid.arrangedSubviews.count, 2)

        grid.setItems([UIView()])
        XCTAssertEqual(grid.arrangedSubviews.count, 1)
        XCTAssertEqual((grid.arrangedSubviews[0] as? UIStackView)?.arrangedSubviews.count, 1)
    }

    func testPaddedLabelPinTopIntrinsicContentSizeIncludesInsets() {
        let label = PaddedLabelPinTop()
        label.text = "Hello"
        label.insets = UIEdgeInsets(top: 3, left: 4, bottom: 5, right: 6)

        let base = UILabel()
        base.text = "Hello"

        XCTAssertEqual(label.intrinsicContentSize.width, base.intrinsicContentSize.width + 10, accuracy: 0.5)
        XCTAssertEqual(label.intrinsicContentSize.height, base.intrinsicContentSize.height + 8, accuracy: 0.5)
    }

    func testChooseMenuButtonConfigureSetsTitleAndLayoutProperties() {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        let button = ChooseMenuButton(imgName: "missing-image", text: "Study together", view: container)
        container.addSubview(button)

        button.configureButton()

        XCTAssertEqual(button.title(for: .normal), "Study together")
        XCTAssertEqual(button.titleColor(for: .normal), .black)
        XCTAssertEqual(button.layer.borderWidth, 1)
        XCTAssertTrue(button.layer.masksToBounds)
    }
}
