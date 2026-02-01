//
//  EWAAssembly.swift
//  EWA
//
//  Created by Дарья Жданок on 26.01.26.
//

import UIKit

enum EWAAssembly {
    static func build() -> UIViewController {
        let presenter: EWAPresenter = EWAPresenter()
        let interactor: EWAInteractor = EWAInteractor(presenter: presenter)
        
        let viewController: RegistrationViewController = RegistrationViewController(
            interactor: interactor
        )

        presenter.registarationView = viewController

        return viewController
    }
}
