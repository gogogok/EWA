//
//  SignInAssembly.swift
//  EWA
//
//  Created by Дарья Жданок on 27.01.26.
//

import UIKit

enum SignUpAssembly {
    static func build() -> UIViewController {
        var presenter: SignUpPresentationLogic = SignUpPresenter()
        let interactor: SignUpBusinessLogic = SignUpInteractor(presenter: presenter)
        
        let viewController: NewUserNameRegistrationViewController = NewUserNameRegistrationViewController(
            interactor: interactor
        )

        presenter.newUserView = viewController
        return viewController
    }
}
