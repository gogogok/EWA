import UIKit

enum ShowMoreEventsAssembly {
    static func build(event: EventResponse) -> UIViewController {
        let presenter: ShowMoreEventsPresentationLogic = ShowMoreEventsPresenter()
        let interactor: ShowMoreEventsBusinessLogic = ShowMoreEventsInteractor(presenter: presenter)
        
        let viewController: ShowMoreEventsViewController = ShowMoreEventsViewController(
            interactor: interactor, event: event
        )

        presenter.view = viewController
        
        return viewController
    }
}
