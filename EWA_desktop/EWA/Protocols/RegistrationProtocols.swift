//
//  EWAProtocols.swift
//  EWA
//
//  Created by Дарья Жданок on 26.01.26.
//

import UIKit

protocol RegistrationBusinessLogic {
    
    typealias Model = EWAModel
    
    func loadEmail(_ request: Model.ModelEmail.Request)
}

protocol RegistrationPresentationLogic {

}
