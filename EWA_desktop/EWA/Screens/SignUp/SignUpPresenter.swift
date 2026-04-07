//
//  SignUpProtocols.swift
//  EWA
//
//  Created by Дарья Жданок on 13.02.26.
//

final class SignUpPresenter : SignUpPresentationLogic  {

    typealias Model = SignUpModel
    
    var newUserView: NewUserNameRegistrationViewController?
    
    func presentIconRegistration(_ response: Model.LoadSignUpModel.Response){
        newUserView?.displayIconRegistrationScreen(Model.LoadSignUpModel.ViewModel(viewController: response.viewController))
    }
}
