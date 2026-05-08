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
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        formatter.locale = Locale(identifier: "ru_RU")

        guard let date = formatter.date(from: "\(alarm.date) \(alarm.time)") else {
            throw NSError(
                domain: "EWA.InvalidDate",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Invalid alarm date"]
            )
        }

        let alarmId = UUID(uuidString: alarm.id) ?? UUID()

        let schedule = Alarm.Schedule.fixed(date)

        let stopButton = AlarmButton(
            text: "Остановить",
            textColor: .white,
            systemImageName: "stop.circle"
        )

        let alarmTitle = LocalizedStringResource(stringLiteral: alarm.description)

        let alert = AlarmPresentation.Alert(
            title: alarmTitle,
            stopButton: stopButton
        )

        let presentation = AlarmPresentation(
            alert: alert
        )

        let attributes = AlarmAttributes(
            presentation: presentation,
            metadata: EWAAlarmMetadata(alarmId: alarm.id),
            tintColor: .purple
        )

        let configuration = AlarmManager.AlarmConfiguration<EWAAlarmMetadata>(
            schedule: schedule,
            attributes: attributes
        )

        try await AlarmManager.shared.schedule(
            id: alarmId,
            configuration: configuration
        )
    }
}
