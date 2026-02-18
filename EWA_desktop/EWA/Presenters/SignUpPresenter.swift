//
//  SignUpProtocols.swift
//  EWA
//
//  Created by Дарья Жданок on 13.02.26.
//

final class SignUpPresenter : SignUpPresentationLogic  {

    typealias Model = EWAModel
    
    var newUserView: NewUserNameRegistrationViewController?
    
    func presentIconRegistration(_ response: Model.ModelProfileIcon.Response){
        newUserView?.displayIconRegistrationScreen(Model.ModelProfileIcon.ViewModel(viewController: response.viewController))
    }
}
