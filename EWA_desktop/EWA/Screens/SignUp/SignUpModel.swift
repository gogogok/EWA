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
        }
        struct Response {
            var viewController: UIViewController
        }
        struct ViewModel {
            var viewController: UIViewController
        }
    }
}
