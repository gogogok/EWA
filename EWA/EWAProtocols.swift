//
//  EWAProtocols.swift
//  EWA
//
//  Created by Дарья Жданок on 26.01.26.
//

import UIKit

protocol EWABusinessLogic {
    
    typealias Model = EWAModel
    
    func loadEmail(_ request: Model.GetEmail.Request)
}

protocol EWAPresentationLogic {
    
    typealias Model = EWAModel
    
    var registarationView: RegistrationViewController? { get set}
    
    func presentRegistration(_ response: Model.GetEmail.Response)
}
