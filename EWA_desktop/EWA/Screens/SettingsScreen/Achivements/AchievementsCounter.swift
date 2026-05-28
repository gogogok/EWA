//
//  AchievementsCounter.swift
//  EWA
//
//  Created by Дарья Жданок on 08.05.2026.
//

import Foundation

final class AchievementsCounter {

    private let userDefaults: UserDefaults
    private let achievementsStore: UserDefaultsAchievementsStore

    init(
        userDefaults: UserDefaults = .standard,
        achievementsStore: UserDefaultsAchievementsStore = UserDefaultsAchievementsStore()
    ) {
        self.userDefaults = userDefaults
        self.achievementsStore = achievementsStore
    }

    // MARK: - Events
    func incrementEventsParticipated() {
        let newCount = userDefaults.integer(forKey: UserDefaultsKeys.eventsParticipated) + 1
        userDefaults.set(newCount, forKey: UserDefaultsKeys.eventsParticipated)

        checkEventsAchievements(count: newCount)
    }

    private func checkEventsAchievements(count: Int) {
        if count >= 5 {
            achievementsStore.setAchievement(.events5, achieved: true)
        }

        if count >= 10 {
            achievementsStore.setAchievement(.events10, achieved: true)
        }

        if count >= 50 {
            achievementsStore.setAchievement(.events50, achieved: true)
        }
    }

    // MARK: - Wake people
    func incrementPeopleWoken() {
        let newCount = userDefaults.integer(forKey: UserDefaultsKeys.peopleWoken) + 1
        userDefaults.set(newCount, forKey: UserDefaultsKeys.peopleWoken)

        checkWakeAchievements(count: newCount)
    }

    private func checkWakeAchievements(count: Int) {
        if count >= 5 {
            achievementsStore.setAchievement(.wake5, achieved: true)
        }

        if count >= 10 {
            achievementsStore.setAchievement(.wake10, achieved: true)
        }

        if count >= 50 {
            achievementsStore.setAchievement(.wake50, achieved: true)
        }
    }

    func updateStudyStreak(minutes: Int) {
        let currentMax = userDefaults.integer(forKey: UserDefaultsKeys.studyLongestStreakMinutes)

        if minutes > currentMax {
            userDefaults.set(minutes, forKey: UserDefaultsKeys.studyLongestStreakMinutes)
        }

        if minutes >= 120 {
            achievementsStore.setAchievement(.study2Hours, achieved: true)
        }
    }

    // MARK: - Messages
    func incrementMessagesSent() {
        let newCount = userDefaults.integer(forKey: UserDefaultsKeys.messagesSent) + 1
        userDefaults.set(newCount, forKey: UserDefaultsKeys.messagesSent)

        if newCount >= 100 {
            achievementsStore.setAchievement(.messages100, achieved: true)
        }
    }
}
