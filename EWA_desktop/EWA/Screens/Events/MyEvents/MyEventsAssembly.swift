import UIKit

enum MyEventsAssembly {
    static func build() -> UIViewController {
        let presenter: MyEventsPresentationLogic = MyEventsPresenter()
        let interactor: MyEventsBusinessLogic = MyEventsInteractor(presenter: presenter)
        
        let viewController: MyEventsViewController = MyEventsViewController(
            interactor: interactor
        )

        presenter.view = viewController
        
        return viewController
    }
}
