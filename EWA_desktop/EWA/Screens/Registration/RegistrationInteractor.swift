//
//  EWAInteractor.swift
//  EWA
//
//  Created by Дарья Жданок on 26.01.26.
//

import FirebaseAuth
import AlarmKit

final class RegistrationInteractor : RegistrationBusinessLogic{
    
    typealias Model = RegistrationModel
    
    var presenter: RegistrationPresenter
    
    init (presenter: RegistrationPresenter) {
        self.presenter = presenter
    }
    
    func loadEmail(_ request: Model.LoadRegistrationModel.Request) {
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://ewa-619ae.web.app")
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        UserDefaults.standard.set(request.email, forKey: UserDefaultsKeys.email)
        Auth.auth().sendSignInLink(toEmail: request.email,
                                   actionCodeSettings: actionCodeSettings) { error in
            if error != nil {
                print(error as Any)
                return
            }
            
            Task {
                await self.requestAlarmPermission()
            }
            
        }
    }
    
    private func requestAlarmPermission() async {
        switch AlarmManager.shared.authorizationState {
            
        case .authorized:
            print("AlarmKit уже разрешён")
            
        case .notDetermined:
            do {
                let state = try await AlarmManager.shared.requestAuthorization()
                print("AlarmKit permission:", state)
            } catch {
                print("AlarmKit permission error:", error)
            }
            
        case .denied:
            print("Пользователь уже отказал в AlarmKit")
            
        @unknown default:
            print("Unknown AlarmKit authorization state")
        }
    }
}
