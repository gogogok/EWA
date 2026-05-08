//
//  HomeScreenAssembly.swift
//  EWA
//
//  Created by Дарья Жданок on 13.02.26.
//
import UIKit

enum HomeScreenAssembly {
    static func build() -> UIViewController {
        var presenter: HomeScreenPresentationLogic = HomeScreenPresenter()
        let interactor: HomeScreenBusinessLogic = HomeScreenInteractor(presenter: presenter)
        
        let viewController: HomeScreenViewController = HomeScreenViewController(
            interactor: interactor
        )

        presenter.homeScreenView = viewController
        
        return viewController
    }
}
