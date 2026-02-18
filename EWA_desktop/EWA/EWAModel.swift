//
//  EWAModel.swift
//  EWA
//
//  Created by Дарья Жданок on 26.01.26.
//

import UIKit

final class EWAModel {
    
    enum ModelEmail {
        struct Request {
            var email: String
        }
        struct Response {
            var email: String
        }
        struct ViewModel {}
    }
    
    enum ModelProfileIcon {
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
    
    enum StartMainScreen {
        struct Request {
            var viewController: UIViewController
            var iconName: String
        }
        struct Response {
            var viewController: UIViewController
        }
        struct ViewModel {
            var viewController: UIViewController
        }
    }
}
