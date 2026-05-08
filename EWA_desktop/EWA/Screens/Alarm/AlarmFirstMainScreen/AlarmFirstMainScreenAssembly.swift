import UIKit

enum AlarmFirstMainScreenAssembly {
    static func build() -> UIViewController {
        let presenter: AlarmFirstMainScreenPresentationLogic = AlarmFirstMainScreenPresenter()
        let interactor: AlarmFirstMainScreenBusinessLogic = AlarmFirstMainScreenInteractor(presenter: presenter)
        
        let viewController: AlarmFirstMainScreenViewController = AlarmFirstMainScreenViewController(
            interactor: interactor
        )

        presenter.view = viewController
        
        return viewController
    }
}
