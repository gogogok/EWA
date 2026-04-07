final class BlackListInteractor : BlackListBusinessLogic{
    
    var presenter: BlackListPresentationLogic
    
    init (presenter: BlackListPresentationLogic) {
        self.presenter = presenter
    }
    
}
