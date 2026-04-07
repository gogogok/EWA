final class AdventureMainScreenInteractor : AdventureMainScreenBusinessLogic{
    
    var presenter: AdventureMainScreenPresentationLogic
    
    init (presenter: AdventureMainScreenPresentationLogic) {
        self.presenter = presenter
    }
    
}
