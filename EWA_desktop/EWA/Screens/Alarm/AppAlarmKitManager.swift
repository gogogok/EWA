//
//  AppAlarmKitManager.swift
//  EWA
//
//  Created by Дарья Жданок on 5.05.26.
//

import Foundation
import AlarmKit
import SwiftUI

struct EWAAlarmMetadata: AlarmMetadata {
    let alarmId: String
}

final class AppAlarmKitManager {

    static let shared = AppAlarmKitManager()

    private init() {}

    func scheduleAlarm(from alarm: AlarmResponse) async throws {
        guard let baseDate = self.parseAlarmDate(date: alarm.date, time: alarm.time) else {
            throw NSError(
                domain: "EWA.InvalidDate",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Invalid alarm date"]
            )
        }

        guard baseDate > Date() else {
            throw NSError(
                domain: "EWA.InvalidDate",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Alarm date is in the past"]
            )
        }

        let alarmTitle = LocalizedStringResource(stringLiteral: alarm.description)

        let stopButton = AlarmButton(
            text: "Остановить",
            textColor: .white,
            systemImageName: "stop.circle"
        )

        let alert = AlarmPresentation.Alert(
            title: alarmTitle,
            stopButton: stopButton
        )

        let presentation = AlarmPresentation(
            alert: alert
        )

        var lastError: Error?

        for offsetSeconds in 0...59 {
            let alarmDate = baseDate.addingTimeInterval(TimeInterval(offsetSeconds))

            guard alarmDate > Date() else {
                continue
            }

            let localAlarmId = UUID()

            let schedule = Alarm.Schedule.fixed(alarmDate)

            let attributes = AlarmAttributes(
                presentation: presentation,
                metadata: EWAAlarmMetadata(alarmId: alarm.id),
                tintColor: .purple
            )

            let configuration = AlarmManager.AlarmConfiguration<EWAAlarmMetadata>(
                schedule: schedule,
                attributes: attributes
            )

            do {
                print("Trying AlarmKit schedule")
                print("Base date:", baseDate)
                print("Offset seconds:", offsetSeconds)
                print("AlarmKit date:", alarmDate)
                print("Local AlarmKit id:", localAlarmId)
                print("Backend alarm id:", alarm.id)

                try await AlarmManager.shared.schedule(
                    id: localAlarmId,
                    configuration: configuration
                )

                print("Alarm scheduled successfully")
                return

            } catch {
                print("AlarmKit error with offset \(offsetSeconds):", error)
                lastError = error
            }
        }

        throw lastError ?? NSError(
            domain: "EWA.AlarmKit",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "Failed to schedule alarm"]
        )
    }
    
    func parseAlarmDate(date: String, time: String) -> Date? {
        let formats = [
            "yyyy-MM-dd HH:mm",
            "dd.MM.yyyy HH:mm"
        ]

        for format in formats {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.timeZone = .current

            if let parsedDate = formatter.date(from: "\(date) \(time)") {
                return parsedDate
            }
        }

        return nil
    }
}
