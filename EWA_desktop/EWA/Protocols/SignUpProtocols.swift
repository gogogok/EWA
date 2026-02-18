//
//  SignUpProtocols.swift
//  EWA
//
//  Created by Дарья Жданок on 13.02.26.
//

import UIKit

protocol SignUpBusinessLogic {
    typealias Model = EWAModel
    
    func loadSecondRegistrationScreen(_ request: Model.ModelProfileIcon.Request)
    
}

protocol SignUpPresentationLogic {
    typealias Model = EWAModel
    
    var newUserView: NewUserNameRegistrationViewController? {get set}
    
    func presentIconRegistration(_ response: Model.ModelProfileIcon.Response)
}
