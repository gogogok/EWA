import UIKit

enum AchievementsAssembly {
    static func build() -> UIViewController {
        let presenter: AchievementsPresentationLogic = AchievementsPresenter()
        let interactor: AchievementsBusinessLogic = AchievementsInteractor(presenter: presenter)
        
        let viewController: AchievementsViewController = AchievementsViewController(
            interactor: interactor
        )

        presenter.view = viewController
        
        return viewController
    }
}
