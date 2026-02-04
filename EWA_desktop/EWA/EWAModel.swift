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
            var name: String
        }
        struct Response {
            var viewController: UIViewController
        }
        struct ViewModel {
            var viewController: UIViewController
        }
    }
    
    enum GetMainScreen {
        struct Request {
            var viewController: UITabBarController
            var iconName: String
        }
        struct Response {
            var viewController: UITabBarController
        }
        struct ViewModel {
            var viewController: UITabBarController
        }
    }
}
