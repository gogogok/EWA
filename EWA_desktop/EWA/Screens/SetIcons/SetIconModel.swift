//
//  SetIconModel.swift
//  EWA
//
//  Created by Дарья Жданок on 18.02.26.
//

import UIKit

final class SetIconsModel {
    
    enum LoadSetIconsModel {
        struct Request {
            var viewController: UIViewController
            var iconName: String
            var indexChosen: Int
        }
        struct Response {
            var viewController: UIViewController
            var indexChosen: Int
        }
        struct ViewModel {
            var indexChosen: Int
            var viewController: UIViewController
        }
    }
}
