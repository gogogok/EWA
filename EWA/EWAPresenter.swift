import UIKit

final class EWAPresenter : EWAPresentationLogic {
    
    typealias Model = EWAModel
    
    weak var registarationView: RegistrationViewController?
    
    weak var newUserView: NewUserNameRegistrationViewController?
    weak var userViewIcons: ProfileIconChooseScreenController?
    
    weak var mainScreenView: MainScreenViewController?
    
    
    func presentIconRegistration(_ response: Model.GetProfileIcon.Response){
        userViewIcons = response.viewController as? ProfileIconChooseScreenController
        newUserView?.displayWishCalendarController(Model.GetProfileIcon.ViewModel(viewController: userViewIcons!))
    }
}
