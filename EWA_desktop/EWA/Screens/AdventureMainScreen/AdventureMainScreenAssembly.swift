import UIKit

enum AdventureMainScreenAssembly {
    static func build() -> UIViewController {
        var presenter: AdventureMainScreenPresentationLogic = AdventureMainScreenPresenter()
        let interactor: AdventureMainScreenBusinessLogic = AdventureMainScreenInteractor(presenter: presenter)
        
        let viewController: AdventureMainScreenViewController = AdventureMainScreenViewController(
            interactor: interactor
        )

        presenter.view = viewController
        
        return viewController
    }
}
