import UIKit

enum ShowMoreEventsAssembly {
    static func build(id: String) -> UIViewController {
        let presenter: ShowMoreEventsPresentationLogic = ShowMoreEventsPresenter()
        let interactor: ShowMoreEventsBusinessLogic = ShowMoreEventsInteractor(presenter: presenter)
        
        let viewController: ShowMoreEventsViewController = ShowMoreEventsViewController(
            interactor: interactor, id: id
        )

        presenter.view = viewController
        
        return viewController
    }
}
