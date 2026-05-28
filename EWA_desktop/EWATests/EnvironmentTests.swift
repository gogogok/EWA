import XCTest
@testable import EWA

final class EnvironmentTests: XCTestCase {
    func testLocalEnvironmentURLs() {
        XCTAssertEqual(Environment.local.baseURL, "http://localhost:10000")
        XCTAssertEqual(Environment.local.webSocketURL, "ws://localhost:10000/ws")
    }

    func testProductionEnvironmentURLs() {
        XCTAssertEqual(Environment.production.baseURL, "https://ewa-pk7o.onrender.com")
        XCTAssertEqual(Environment.production.webSocketURL, "wss://ewa-pk7o.onrender.com/ws")
    }

    func testCurrentEnvironmentIsLocal() {
        XCTAssertEqual(Environment.current.baseURL, Environment.local.baseURL)
        XCTAssertEqual(Environment.current.webSocketURL, Environment.local.webSocketURL)
    }
}
