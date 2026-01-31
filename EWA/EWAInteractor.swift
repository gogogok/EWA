//
//  EWAInteractor.swift
//  EWA
//
//  Created by Дарья Жданок on 26.01.26.
//

import FirebaseAuth

final class EWAInteractor : EWABusinessLogic{
    
    var presenter: EWAPresenter
    
    init (presenter: EWAPresenter) {
        self.presenter = presenter
    }
    
    func loadEmail(_ request: Model.GetEmail.Request) {
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://ewa-619ae.web.app")
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        UserDefaults.standard.set(request.email, forKey: "EmailForSignIn")
        Auth.auth().sendSignInLink(toEmail: request.email,
                                   actionCodeSettings: actionCodeSettings) { error in
            if error != nil {
                return
            }
            
        }
    }
    
    func loadSecondRegistrationScreen(_ request: Model.GetProfileIcon.Request) {
        presenter.presentIconRegistration(Model.GetProfileIcon.Response(viewController: request.viewController))
    }
    
    func loadMainScreen(_ request: Model.GetMainScreen.Request) {
        presenter.presentMainScreen(Model.GetMainScreen.Response(viewController: request.viewController))
    }
}
