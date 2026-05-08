final class EnterPasswordScreenInteractor : EnterPasswordScreenBusinessLogic{
    
    var presenter: EnterPasswordScreenPresentationLogic
    
    init (presenter: EnterPasswordScreenPresentationLogic) {
        self.presenter = presenter
    }
    
}
