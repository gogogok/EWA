import UIKit

enum AlarmDetailsAssembly {
    static func build(alarm: AlarmResponse) -> UIViewController {
        let presenter: AlarmDetailsPresentationLogic = AlarmDetailsPresenter()
        let interactor: AlarmDetailsBusinessLogic = AlarmDetailsInteractor(presenter: presenter)
        
        let viewController: AlarmDetailsViewController = AlarmDetailsViewController(
            interactor: interactor, alarm: alarm
        )

        presenter.view = viewController
        
        return viewController
    }
}
