import UIKit

enum CreateNewRoomAssembly {
    static func build() -> UIViewController {
        var presenter: CreateNewRoomPresentationLogic = CreateNewRoomPresenter()
        let interactor: CreateNewRoomBusinessLogic = CreateNewRoomInteractor(presenter: presenter)
        
        let viewController: CreateNewRoomViewController = CreateNewRoomViewController(
            interactor: interactor
        )

        presenter.view = viewController
        
        return viewController
    }
}
