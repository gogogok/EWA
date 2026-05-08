//
//  SignUpProtocols.swift
//  EWA
//
//  Created by Дарья Жданок on 13.02.26.
//

import UIKit

protocol SignUpBusinessLogic {
    typealias Model = SignUpModel
    
    func loadSecondRegistrationScreen(_ request: Model.LoadSignUpModel.Request)
    
}

protocol SignUpPresentationLogic {
    typealias Model = SignUpModel
    
    var newUserView: NewUserNameRegistrationViewController? {get set}
    
    func presentIconRegistration(_ response: Model.LoadSignUpModel.Response)
}
