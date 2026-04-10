import UIKit

enum ShowMoreEventsAssembly {
    static func build() -> UIViewController {
        let presenter: ShowMoreEventsPresentationLogic = ShowMoreEventsPresenter()
        let interactor: ShowMoreEventsBusinessLogic = ShowMoreEventsInteractor(presenter: presenter)
        
        let viewController: ShowMoreEventsViewController = ShowMoreEventsViewController(
            interactor: interactor
        )

        presenter.view = viewController
        
        return viewController
    }
}
