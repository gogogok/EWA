import Foundation

import Foundation

final class UserDefaultsAchievementsStore {
    private let userDefaults: UserDefaults
    private let keys = UserDefaultsKeys.self

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func setAchievement(_ achievement: AchievementID, achieved: Bool) {
        userDefaults.set(achieved, forKey: keys.achievementPrefix + achievement.rawValue)
    }

    func isAchievementUnlocked(_ achievement: AchievementID) -> Bool {
        userDefaults.bool(forKey: keys.achievementPrefix + achievement.rawValue)
    }
}
