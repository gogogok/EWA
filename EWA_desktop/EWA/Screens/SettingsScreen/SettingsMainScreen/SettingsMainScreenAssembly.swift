import UIKit

enum SettingsMainScreenAssembly {
    static func build() -> UIViewController {
        let presenter: SettingsMainScreenPresentationLogic = SettingsMainScreenPresenter()
        let interactor: SettingsMainScreenBusinessLogic = SettingsMainScreenInteractor(presenter: presenter)
        
        let viewController: SettingsMainScreenViewController = SettingsMainScreenViewController(
            interactor: interactor
        )

        presenter.view = viewController
        
        return viewController
    }
}
