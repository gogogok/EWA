//
//  AchievementsEnum.swift
//  EWA
//
//  Created by Дарья Жданок on 08.05.2026.
//

enum AchievementsEnum {
    static let eventFive = "Посититель"
    static let eventTen = "Ценитель"
    static let eventFifty = "Эксперт"
    
    static let clockFive = "Жаворонок"
    static let clockTen = "Просветлённый"
    static let clockFifty = "Мастер"
    
    static let massage = "Мастер"
    static let study = "Учёный"
}

enum AchievementID: String {
    case events5 = "events_5"
    case events10 = "events_10"
    case events50 = "events_50"

    case wake5 = "wake_5"
    case wake10 = "wake_10"
    case wake50 = "wake_50"

    case study2Hours = "study_2_hours"

    case messages100 = "messages_100"
}
