//
//  SignInAssembly.swift
//  EWA
//
//  Created by Дарья Жданок on 27.01.26.
//

import UIKit

enum SignInAssembly {
    static func build() -> UIViewController {
        let presenter: EWAPresenter = EWAPresenter()
        let interactor: EWAInteractor = EWAInteractor(presenter: presenter)
        
        let viewController: NewUserNameRegistrationViewController = NewUserNameRegistrationViewController(
            interactor: interactor
        )

        presenter.newUserView = viewController

        return viewController
    }
}
