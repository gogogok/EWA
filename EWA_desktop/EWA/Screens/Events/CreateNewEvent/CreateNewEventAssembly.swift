import UIKit

enum CreateNewEventAssembly {
    static func build(mode: CreateNewEventViewController.ScreenMode = .create) -> UIViewController {
        let presenter: CreateNewEventPresentationLogic = CreateNewEventPresenter()
        let interactor: CreateNewEventBusinessLogic = CreateNewEventInteractor(presenter: presenter)
        
        let viewController: CreateNewEventViewController = CreateNewEventViewController(
            interactor: interactor, mode: mode
        )

        presenter.view = viewController
        
        return viewController
    }
}
