//
//  MainScreenAssembly.swift
//  EWA
//
//  Created by Дарья Жданок on 27.01.26.
//

import UIKit

enum MainScreenAssembly {
    static func build() -> UIViewController {
        let presenter: EWAPresenter = EWAPresenter()
        let interactor: EWAInteractor = EWAInteractor(presenter: presenter)
        
        let viewController: TabScreensController = TabScreensController(
            interactor: interactor
        )

        presenter.mainScreenView = viewController

        return viewController
    }
}
