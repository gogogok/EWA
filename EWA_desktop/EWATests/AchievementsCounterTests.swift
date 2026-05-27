import XCTest
@testable import EWA

final class AchievementsCounterTests: XCTestCase {
    private var userDefaults: UserDefaults!
    private var store: UserDefaultsAchievementsStore!
    private var counter: AchievementsCounter!

    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults(suiteName: "AchievementsCounterTests")!
        userDefaults.removePersistentDomain(forName: "AchievementsCounterTests")
        store = UserDefaultsAchievementsStore(userDefaults: userDefaults)
        counter = AchievementsCounter(userDefaults: userDefaults, achievementsStore: store)
    }

    override func tearDown() {
        userDefaults.removePersistentDomain(forName: "AchievementsCounterTests")
        userDefaults = nil
        store = nil
        counter = nil
        super.tearDown()
    }

    func testIncrementEventsParticipatedIncreasesCounter() {
        counter.incrementEventsParticipated()
        counter.incrementEventsParticipated()
        counter.incrementEventsParticipated()

        XCTAssertEqual(userDefaults.integer(forKey: UserDefaultsKeys.eventsParticipated), 3)
        XCTAssertFalse(store.isAchievementUnlocked(.events5))
    }

    func testEventsAchievementsUnlockAt5_10_50() {
        for _ in 0..<5 { counter.incrementEventsParticipated() }
        XCTAssertTrue(store.isAchievementUnlocked(.events5))
        XCTAssertFalse(store.isAchievementUnlocked(.events10))
        XCTAssertFalse(store.isAchievementUnlocked(.events50))

        for _ in 0..<5 { counter.incrementEventsParticipated() }
        XCTAssertTrue(store.isAchievementUnlocked(.events10))
        XCTAssertFalse(store.isAchievementUnlocked(.events50))

        for _ in 0..<40 { counter.incrementEventsParticipated() }
        XCTAssertTrue(store.isAchievementUnlocked(.events50))
        XCTAssertEqual(userDefaults.integer(forKey: UserDefaultsKeys.eventsParticipated), 50)
    }

    func testWakeAchievementsUnlockAt5_10_50() {
        for _ in 0..<5 { counter.incrementPeopleWoken() }
        XCTAssertTrue(store.isAchievementUnlocked(.wake5))
        XCTAssertFalse(store.isAchievementUnlocked(.wake10))
        XCTAssertFalse(store.isAchievementUnlocked(.wake50))

        for _ in 0..<5 { counter.incrementPeopleWoken() }
        XCTAssertTrue(store.isAchievementUnlocked(.wake10))
        XCTAssertFalse(store.isAchievementUnlocked(.wake50))

        for _ in 0..<40 { counter.incrementPeopleWoken() }
        XCTAssertTrue(store.isAchievementUnlocked(.wake50))
        XCTAssertEqual(userDefaults.integer(forKey: UserDefaultsKeys.peopleWoken), 50)
    }

    func testStudyStreakSavesOnlyLongestValue() {
        counter.updateStudyStreak(minutes: 90)
        counter.updateStudyStreak(minutes: 60)

        XCTAssertEqual(userDefaults.integer(forKey: UserDefaultsKeys.studyLongestStreakMinutes), 90)
        XCTAssertFalse(store.isAchievementUnlocked(.study2Hours))
    }

    func testStudyAchievementUnlocksFrom120Minutes() {
        counter.updateStudyStreak(minutes: 120)

        XCTAssertEqual(userDefaults.integer(forKey: UserDefaultsKeys.studyLongestStreakMinutes), 120)
        XCTAssertTrue(store.isAchievementUnlocked(.study2Hours))
    }

    func testMessagesAchievementUnlocksAt100() {
        for _ in 0..<99 { counter.incrementMessagesSent() }
        XCTAssertEqual(userDefaults.integer(forKey: UserDefaultsKeys.messagesSent), 99)
        XCTAssertFalse(store.isAchievementUnlocked(.messages100))

        counter.incrementMessagesSent()
        XCTAssertEqual(userDefaults.integer(forKey: UserDefaultsKeys.messagesSent), 100)
        XCTAssertTrue(store.isAchievementUnlocked(.messages100))
    }
}
