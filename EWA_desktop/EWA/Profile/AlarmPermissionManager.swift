import Foundation
import UIKit
import AlarmKit

final class AlarmPermissionManager {

    static let shared = AlarmPermissionManager()

    private init() {}

    func requestPermission() async -> Bool {
        switch AlarmManager.shared.authorizationState {

        case .authorized:
            return true

        case .notDetermined:
            do {
                let state = try await AlarmManager.shared.requestAuthorization()
                return state == .authorized
            } catch {
                print("AlarmKit permission error:", error)
                return false
            }

        case .denied:
            return false

        @unknown default:
            return false
        }
    }

    @MainActor
    func showDeniedAlert(from viewController: UIViewController) {
        let alert = UIAlertController(
            title: "Будильники запрещены",
            message: "Вы уже отказали в разрешении. Его можно включить в настройках приложения.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Ок", style: .cancel))

        viewController.present(alert, animated: true)
    }
}
