//
//  RegistrationModel.swift
//  EWA
//
//  Created by Дарья Жданок on 18.02.26.
//

import UIKit

final class RegistrationModel {
    
    enum LoadRegistrationModel {
        struct Request {
            var email: String
        }
        struct Response {
            var email: String
        }
        struct ViewModel {}
    }
}
