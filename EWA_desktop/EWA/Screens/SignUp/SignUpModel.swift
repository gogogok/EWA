//
//  SignUpModel.swift
//  EWA
//
//  Created by Дарья Жданок on 18.02.26.
//

import UIKit

final class SignUpModel {
    
    enum LoadSignUpModel {
        struct Request {
            var viewController: UIViewController
            var name: String
            var draft: RegistrationUserDraft?
        }
        struct Response {
            var viewController: UIViewController
            var draft: RegistrationUserDraft
        }
        struct ViewModel {
            var viewController: UIViewController
            var draft: RegistrationUserDraft
        }
    }
}
