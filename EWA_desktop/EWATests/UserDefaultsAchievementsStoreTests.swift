import XCTest
@testable import EWA

final class UserDefaultsAchievementsStoreTests: XCTestCase {
    private var userDefaults: UserDefaults!
    private var store: UserDefaultsAchievementsStore!

    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults(suiteName: "UserDefaultsAchievementsStoreTests")!
        userDefaults.removePersistentDomain(forName: "UserDefaultsAchievementsStoreTests")
        store = UserDefaultsAchievementsStore(userDefaults: userDefaults)
    }

    override func tearDown() {
        userDefaults.removePersistentDomain(forName: "UserDefaultsAchievementsStoreTests")
        userDefaults = nil
        store = nil
        super.tearDown()
    }

    func testNewAchievementIsLockedByDefault() {
        XCTAssertFalse(store.isAchievementUnlocked(.events5))
    }

    func testSetAchievementToTrueUnlocksIt() {
        store.setAchievement(.events5, achieved: true)

        XCTAssertTrue(store.isAchievementUnlocked(.events5))
        XCTAssertTrue(userDefaults.bool(forKey: UserDefaultsKeys.achievementPrefix + AchievementID.events5.rawValue))
    }

    func testSetAchievementToFalseLocksItAgain() {
        store.setAchievement(.messages100, achieved: true)
        store.setAchievement(.messages100, achieved: false)

        XCTAssertFalse(store.isAchievementUnlocked(.messages100))
    }
}
