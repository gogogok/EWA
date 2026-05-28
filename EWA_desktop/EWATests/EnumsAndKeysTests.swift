import XCTest
@testable import EWA

final class EnumsAndKeysTests: XCTestCase {
    func testAchievementIDRawValuesMatchUserDefaultsSuffixes() {
        XCTAssertEqual(AchievementID.events5.rawValue, "events_5")
        XCTAssertEqual(AchievementID.events10.rawValue, "events_10")
        XCTAssertEqual(AchievementID.events50.rawValue, "events_50")
        XCTAssertEqual(AchievementID.wake5.rawValue, "wake_5")
        XCTAssertEqual(AchievementID.wake10.rawValue, "wake_10")
        XCTAssertEqual(AchievementID.wake50.rawValue, "wake_50")
        XCTAssertEqual(AchievementID.study2Hours.rawValue, "study_2_hours")
        XCTAssertEqual(AchievementID.messages100.rawValue, "messages_100")
    }

    func testAchievementStorageKeysUseExpectedPrefix() {
        XCTAssertEqual(UserDefaultsKeys.achievementPrefix + AchievementID.events5.rawValue, "achievement_events_5")
        XCTAssertEqual(UserDefaultsKeys.achievementPrefix + AchievementID.messages100.rawValue, "achievement_messages_100")
    }

    func testUserDefaultsKeysAreStable() {
        XCTAssertEqual(UserDefaultsKeys.id, "userId")
        XCTAssertEqual(UserDefaultsKeys.username, "userName")
        XCTAssertEqual(UserDefaultsKeys.iconName, "iconName")
        XCTAssertEqual(UserDefaultsKeys.email, "email")
        XCTAssertEqual(UserDefaultsKeys.eventsParticipated, "eventsParticipated")
        XCTAssertEqual(UserDefaultsKeys.peopleWoken, "peopleWoken")
        XCTAssertEqual(UserDefaultsKeys.studyLongestStreakMinutes, "studyLongestStreakMinutes")
        XCTAssertEqual(UserDefaultsKeys.messagesSent, "messagesSent")
    }

    func testSectionEventsTitlesAndOrder() {
        XCTAssertEqual(SectionEvents.allCases.count, 2)
        XCTAssertEqual(SectionEvents.created.rawValue, 0)
        XCTAssertEqual(SectionEvents.registered.rawValue, 1)
        XCTAssertEqual(SectionEvents.created.title, "Мои запросы")
        XCTAssertEqual(SectionEvents.registered.title, "Принятые запросы")
    }

    func testSectionAlarmsTitlesAndOrder() {
        XCTAssertEqual(SectionAlarms.allCases.count, 2)
        XCTAssertEqual(SectionAlarms.created.rawValue, 0)
        XCTAssertEqual(SectionAlarms.registered.rawValue, 1)
        XCTAssertEqual(SectionAlarms.created.title, "Разбудить меня")
        XCTAssertEqual(SectionAlarms.registered.title, "Нужно разбудить")
    }

    func testAchievementTitlesAreStable() {
        XCTAssertEqual(AchievementsEnum.eventFive, "Посититель")
        XCTAssertEqual(AchievementsEnum.eventTen, "Ценитель")
        XCTAssertEqual(AchievementsEnum.eventFifty, "Эксперт")
        XCTAssertEqual(AchievementsEnum.clockFive, "Жаворонок")
        XCTAssertEqual(AchievementsEnum.clockTen, "Просветлённый")
        XCTAssertEqual(AchievementsEnum.clockFifty, "Мастер")
        XCTAssertEqual(AchievementsEnum.massage, "Мастер")
        XCTAssertEqual(AchievementsEnum.study, "Учёный")
    }
}
