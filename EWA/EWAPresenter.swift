import UIKit

final class EWAPresenter : EWAPresentationLogic {
    
    weak var registarationView: RegistrationViewController?
    weak var newUserView: NewUserRegistrationViewController?
    weak var mainScreenView: MainScreenViewController?
    
    func presentRegistration(_ response: Model.GetEmail.Response) {
        
    }
    
}
