//
//  SignUpProtocols.swift
//  EWA
//
//  Created by Дарья Жданок on 13.02.26.
//

import Foundation
import FirebaseAuth

final class SignUpInteractor : SignUpBusinessLogic{
    typealias Model = SignUpModel
    
    var presenter: SignUpPresentationLogic
    
    init (presenter: SignUpPresentationLogic) {
        self.presenter = presenter
    }
    
    func loadSecondRegistrationScreen(_ request: Model.LoadSignUpModel.Request) {
        UserDefaults.standard.set(request.name, forKey: UserDefaultsKeys.username)
        guard var draft = request.draft else {return}
        draft.name = request.name
        presenter.presentIconRegistration(Model.LoadSignUpModel.Response(viewController: request.viewController, draft: draft))
    }
    
}
