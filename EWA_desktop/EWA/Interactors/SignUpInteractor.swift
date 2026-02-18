//
//  SignUpProtocols.swift
//  EWA
//
//  Created by Дарья Жданок on 13.02.26.
//

import Foundation
import FirebaseAuth

final class SignUpInteractor : SignUpBusinessLogic{
    
    var presenter: SignUpPresentationLogic
    let userWorker = UserProfileManager()
    
    init (presenter: SignUpPresentationLogic) {
        self.presenter = presenter
    }
    
    func loadSecondRegistrationScreen(_ request: Model.ModelProfileIcon.Request) {
        let uid = Auth.auth().currentUser!.uid
        userWorker.updateName(id: uid, name: request.name)
        presenter.presentIconRegistration(Model.ModelProfileIcon.Response(viewController: request.viewController))
    }
    
}
