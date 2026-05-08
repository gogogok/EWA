import UIKit

enum StudyMainScreenAssembly {
    static func build() -> UIViewController {
        var presenter: StudyMainScreenPresentationLogic = StudyMainScreenPresenter()
        let interactor: StudyMainScreenBusinessLogic = StudyMainScreenInteractor(presenter: presenter)
        
        let viewController: StudyMainScreenViewController = StudyMainScreenViewController(
            interactor: interactor
        )

        presenter.view = viewController
        
        return viewController
    }
}
