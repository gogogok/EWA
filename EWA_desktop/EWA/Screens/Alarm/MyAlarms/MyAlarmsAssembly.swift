import UIKit

enum MyAlarmsAssembly {
    static func build() -> UIViewController {
        let presenter: MyAlarmsPresentationLogic = MyAlarmsPresenter()
        let interactor: MyAlarmsBusinessLogic = MyAlarmsInteractor(presenter: presenter)
        
        let viewController: MyAlarmsViewController = MyAlarmsViewController(
            interactor: interactor
        )

        presenter.view = viewController
        
        return viewController
    }
}
