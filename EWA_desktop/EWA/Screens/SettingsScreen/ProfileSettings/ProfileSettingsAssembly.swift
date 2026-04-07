import UIKit

enum ProfileSettingsAssembly {
    static func build() -> UIViewController {
        let presenter: ProfileSettingsPresentationLogic = ProfileSettingsPresenter()
        let interactor: ProfileSettingsBusinessLogic = ProfileSettingsInteractor(presenter: presenter)
        
        let viewController: ProfileSettingsViewController = ProfileSettingsViewController(
            interactor: interactor
        )

        presenter.view = viewController
        
        return viewController
    }
}
