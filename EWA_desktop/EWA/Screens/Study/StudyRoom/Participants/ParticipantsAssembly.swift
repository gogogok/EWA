import UIKit

enum ParticipantsAssembly {
    static func build(room: StudyResponse) -> UIViewController {
        var presenter: ParticipantsPresentationLogic = ParticipantsPresenter()
        let interactor: ParticipantsBusinessLogic = ParticipantsInteractor(presenter: presenter)
        
        let viewController: ParticipantsViewController = ParticipantsViewController(
            interactor: interactor, room: room
        )

        presenter.view = viewController
        
        return viewController
    }
}
