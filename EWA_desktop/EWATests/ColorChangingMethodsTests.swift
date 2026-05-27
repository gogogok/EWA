import XCTest
import UIKit
@testable import EWA

final class ColorChangingMethodsTests: XCTestCase {
    func testGetHEXColorReturnsParsedColorForValidHex() {
        let color = ColorChangindMethods.getHEXColor(hex: "#00D78C")
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        XCTAssertTrue(color.getRed(&red, green: &green, blue: &blue, alpha: &alpha))
        XCTAssertEqual(red, 0.0, accuracy: 0.001)
        XCTAssertEqual(green, 215.0 / 255.0, accuracy: 0.001)
        XCTAssertEqual(blue, 140.0 / 255.0, accuracy: 0.001)
        XCTAssertEqual(alpha, 1.0, accuracy: 0.001)
    }

    func testUIColorHexReturnsNilForInvalidString() {
        let color = UIColor(hex: "wrong")

        XCTAssertNil(color)
    }

    func testGetRandomColorHasFullAlpha() {
        let color = ColorChangindMethods.getRandomColor()
        var alpha: CGFloat = 0

        XCTAssertTrue(color.getRed(nil, green: nil, blue: nil, alpha: &alpha))
        XCTAssertEqual(alpha, 1.0, accuracy: 0.001)
    }
}
