//
//  SetIconsAssembly.swift
//  EWA
//
//  Created by Дарья Жданок on 13.02.26.
//

import UIKit

enum SetIconsAssembly {
    static func build(edit: Bool = false) -> UIViewController {
        var presenter: SetIconPresentationLogic = SetIconPresenter()
        let interactor: SetIconBusinessLogic = SetIconInteractor(presenter: presenter)
        
        let viewController: ProfileIconChooseScreenController = ProfileIconChooseScreenController(
            interactor: interactor,
            edition: edit
        )

        presenter.userViewIcons = viewController
        
        return viewController
    }
}
