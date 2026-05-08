import UIKit

enum CreateNewAlarmAssembly {
    static func build(mode: CreateNewAlarmViewController.ScreenMode = .create) -> UIViewController {
        let presenter: CreateNewAlarmPresentationLogic = CreateNewAlarmPresenter()
        let interactor: CreateNewAlarmBusinessLogic = CreateNewAlarmInteractor(presenter: presenter)
        
        let viewController: CreateNewAlarmViewController = CreateNewAlarmViewController(
            interactor: interactor, mode: mode
        )

        presenter.view = viewController
        
        return viewController
    }
}
