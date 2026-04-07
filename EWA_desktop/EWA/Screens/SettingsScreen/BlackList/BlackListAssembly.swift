import UIKit

enum BlackListAssembly {
    static func build() -> UIViewController {
        let presenter: BlackListPresentationLogic = BlackListPresenter()
        let interactor: BlackListBusinessLogic = BlackListInteractor(presenter: presenter)
        
        let viewController: BlackListViewController = BlackListViewController(
            interactor: interactor
        )

        presenter.view = viewController
        
        return viewController
    }
}
