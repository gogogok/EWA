import UIKit

enum EnterPasswordScreenAssembly {
    static func build(password: String, room: StudyResponse) -> UIViewController {
        let presenter: EnterPasswordScreenPresentationLogic = EnterPasswordScreenPresenter()
        let interactor: EnterPasswordScreenBusinessLogic = EnterPasswordScreenInteractor(presenter: presenter)
        
        let viewController: EnterPasswordScreenViewController = EnterPasswordScreenViewController(
            interactor: interactor,
            password: password,
            room: room
        )

        presenter.view = viewController
        
        return viewController
    }
}
