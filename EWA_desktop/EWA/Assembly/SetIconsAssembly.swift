//
//  SetIconsAssembly.swift
//  EWA
//
//  Created by Дарья Жданок on 13.02.26.
//

import UIKit

enum SetIconsAssembly {
    static func build() -> UIViewController {
        var presenter: SetIconPresentationLogic = SetIconPresenter()
        let interactor: SetIconBusinessLogic = SetIconInteractor(presenter: presenter)
        
        let viewController: ProfileIconChooseScreenController = ProfileIconChooseScreenController(
            interactor: interactor
        )

        presenter.userViewIcons = viewController
        
        return viewController
    }
}
