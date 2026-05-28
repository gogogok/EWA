import XCTest
import UIKit
@testable import EWA

final class UIUtilitiesTests: XCTestCase {
    func testUIColorHexParsesWhite() throws {
        let color = try XCTUnwrap(UIColor(hex: "#FFFFFF"))
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        XCTAssertTrue(color.getRed(&red, green: &green, blue: &blue, alpha: &alpha))
        XCTAssertEqual(red, 1, accuracy: 0.001)
        XCTAssertEqual(green, 1, accuracy: 0.001)
        XCTAssertEqual(blue, 1, accuracy: 0.001)
        XCTAssertEqual(alpha, 1, accuracy: 0.001)
    }

    func testUIColorHexParsesWithoutHash() throws {
        let color = try XCTUnwrap(UIColor(hex: "000000"))
        var red: CGFloat = 1
        var green: CGFloat = 1
        var blue: CGFloat = 1
        var alpha: CGFloat = 0

        XCTAssertTrue(color.getRed(&red, green: &green, blue: &blue, alpha: &alpha))
        XCTAssertEqual(red, 0, accuracy: 0.001)
        XCTAssertEqual(green, 0, accuracy: 0.001)
        XCTAssertEqual(blue, 0, accuracy: 0.001)
        XCTAssertEqual(alpha, 1, accuracy: 0.001)
    }

    func testUIColorHexReturnsNilForInvalidString() {
        XCTAssertNil(UIColor(hex: "not-a-color"))
    }

    func testPaddedTextFieldInsetsTextRects() {
        let textField = PaddedTextField(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        textField.insets = UIEdgeInsets(top: 4, left: 6, bottom: 8, right: 10)
        let bounds = CGRect(x: 0, y: 0, width: 100, height: 50)
        let expected = CGRect(x: 6, y: 4, width: 84, height: 38)

        XCTAssertEqual(textField.textRect(forBounds: bounds), expected)
        XCTAssertEqual(textField.editingRect(forBounds: bounds), expected)
        XCTAssertEqual(textField.placeholderRect(forBounds: bounds), expected)
    }

    func testUnderlinedPaddedTextFieldInsetsTextRects() {
        let textField = UnderlinedPaddedTextField(frame: CGRect(x: 0, y: 0, width: 120, height: 60))
        textField.insets = UIEdgeInsets(top: 5, left: 7, bottom: 9, right: 11)
        let bounds = CGRect(x: 0, y: 0, width: 120, height: 60)
        let expected = CGRect(x: 7, y: 5, width: 102, height: 46)

        XCTAssertEqual(textField.textRect(forBounds: bounds), expected)
        XCTAssertEqual(textField.editingRect(forBounds: bounds), expected)
        XCTAssertEqual(textField.placeholderRect(forBounds: bounds), expected)
    }

    func testPaddedLabelIntrinsicContentSizeIncludesInsets() {
        let label = PaddedLabel()
        label.text = "Test"
        label.insets = UIEdgeInsets(top: 2, left: 3, bottom: 4, right: 5)

        let baseSize = UILabel()
        baseSize.text = "Test"
        let expectedWidth = baseSize.intrinsicContentSize.width + 8
        let expectedHeight = baseSize.intrinsicContentSize.height + 6

        XCTAssertEqual(label.intrinsicContentSize.width, expectedWidth, accuracy: 0.5)
        XCTAssertEqual(label.intrinsicContentSize.height, expectedHeight, accuracy: 0.5)
    }

    func testSearchInputViewTextGetterAndSetter() {
        let view = SearchInputView(placeholder: "Search")

        XCTAssertEqual(view.text, "")

        view.text = "math"

        XCTAssertEqual(view.text, "math")
        XCTAssertEqual(view.textField.text, "math")
    }

    func testGradientActionButtonConfigureSetsTitle() {
        let button = GradientActionButton(frame: CGRect(x: 0, y: 0, width: 200, height: 60))

        button.configure(title: "Study together", image: nil)

        XCTAssertEqual(button.customTitleLabel.text, "Study together")
    }
}
