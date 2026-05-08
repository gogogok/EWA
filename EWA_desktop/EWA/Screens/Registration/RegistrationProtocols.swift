//
//  EWAProtocols.swift
//  EWA
//
//  Created by Дарья Жданок on 26.01.26.
//

import UIKit

protocol RegistrationBusinessLogic {
    
    typealias Model = RegistrationModel
    
    func loadEmail(_ request: Model.LoadRegistrationModel.Request)
}

protocol RegistrationPresentationLogic {

}
