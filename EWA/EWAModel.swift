//
//  EWAModel.swift
//  EWA
//
//  Created by Дарья Жданок on 26.01.26.
//

import UIKit

final class EWAModel {
    
    enum GetEmail {
        struct Request {
            var email: String
        }
        struct Response {
            var email: String
        }
        struct ViewModel {}
    }
    
    enum GetProfileIcon {
        struct Request {
            var viewController: UIViewController
        }
        struct Response {
            var viewController: UIViewController
        }
        struct ViewModel {
            var viewController: UIViewController
        }
    }
}
