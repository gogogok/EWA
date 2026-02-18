//
//  EWAAssembly.swift
//  EWA
//
//  Created by Дарья Жданок on 26.01.26.
//

import UIKit

enum RegistrationAssembly {
    static func build() -> UIViewController {
        let presenter: RegistrationPresentationLogic = RegistrationPresenter()
        let interactor: RegistrationInteractor = RegistrationInteractor(presenter: presenter as! RegistrationPresenter)
        
        let viewController: RegistrationViewController = RegistrationViewController(
            interactor: interactor
        )

        return viewController
    }
}
