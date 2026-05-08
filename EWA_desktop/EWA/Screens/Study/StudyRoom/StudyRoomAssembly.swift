import UIKit

enum StudyRoomAssembly {
    static func build(room: StudyResponse) -> UIViewController {
        var presenter: StudyRoomPresentationLogic = StudyRoomPresenter()
        let interactor: StudyRoomBusinessLogic = StudyRoomInteractor(presenter: presenter)
        
        let viewController: StudyRoomViewController = StudyRoomViewController(
            interactor: interactor, room: room
        )

        presenter.view = viewController
        
        return viewController
    }
}
