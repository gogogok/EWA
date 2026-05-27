import XCTest
@testable import EWA

final class AchievementsBoundaryTests: XCTestCase {
    private var userDefaults: UserDefaults!
    private var store: UserDefaultsAchievementsStore!
    private var counter: AchievementsCounter!

    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults(suiteName: "AchievementsBoundaryTests")!
        userDefaults.removePersistentDomain(forName: "AchievementsBoundaryTests")
        store = UserDefaultsAchievementsStore(userDefaults: userDefaults)
        counter = AchievementsCounter(userDefaults: userDefaults, achievementsStore: store)
    }

    override func tearDown() {
        userDefaults.removePersistentDomain(forName: "AchievementsBoundaryTests")
        userDefaults = nil
        store = nil
        counter = nil
        super.tearDown()
    }

    func testEventsAchievementDoesNotUnlockBefore5() {
        for _ in 0..<4 { counter.incrementEventsParticipated() }

        XCTAssertEqual(userDefaults.integer(forKey: UserDefaultsKeys.eventsParticipated), 4)
        XCTAssertFalse(store.isAchievementUnlocked(.events5))
        XCTAssertFalse(store.isAchievementUnlocked(.events10))
        XCTAssertFalse(store.isAchievementUnlocked(.events50))
    }

    func testWakeAchievementDoesNotUnlockBefore5() {
        for _ in 0..<4 { counter.incrementPeopleWoken() }

        XCTAssertEqual(userDefaults.integer(forKey: UserDefaultsKeys.peopleWoken), 4)
        XCTAssertFalse(store.isAchievementUnlocked(.wake5))
        XCTAssertFalse(store.isAchievementUnlocked(.wake10))
        XCTAssertFalse(store.isAchievementUnlocked(.wake50))
    }

    func testMessagesAchievementDoesNotUnlockAt99() {
        for _ in 0..<99 { counter.incrementMessagesSent() }

        XCTAssertEqual(userDefaults.integer(forKey: UserDefaultsKeys.messagesSent), 99)
        XCTAssertFalse(store.isAchievementUnlocked(.messages100))
    }

    func testStudyAchievementDoesNotUnlockAt119Minutes() {
        counter.updateStudyStreak(minutes: 119)

        XCTAssertEqual(userDefaults.integer(forKey: UserDefaultsKeys.studyLongestStreakMinutes), 119)
        XCTAssertFalse(store.isAchievementUnlocked(.study2Hours))
    }

    func testStudyLongestStreakCanIncreaseAfterLowerValue() {
        counter.updateStudyStreak(minutes: 45)
        counter.updateStudyStreak(minutes: 121)

        XCTAssertEqual(userDefaults.integer(forKey: UserDefaultsKeys.studyLongestStreakMinutes), 121)
        XCTAssertTrue(store.isAchievementUnlocked(.study2Hours))
    }
}
