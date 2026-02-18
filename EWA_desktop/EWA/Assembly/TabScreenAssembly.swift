//
//  MainScreenAssembly.swift
//  EWA
//
//  Created by Дарья Жданок on 27.01.26.
//

import UIKit

enum TabScreenAssembly {
    static func build() -> UIViewController {
        let presenter: TabScreenPresentationLogic = TabScreenPresenter()
        let interactor: TabScreenBusinessLogic = TabScreenInteractor(presenter: presenter)
        
        let viewController: TabScreensController = TabScreensController(
            interactor: interactor
        )

        return viewController
    }
}
