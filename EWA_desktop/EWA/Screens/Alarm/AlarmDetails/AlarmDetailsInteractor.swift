final class AlarmDetailsInteractor : AlarmDetailsBusinessLogic{
    
    var presenter: AlarmDetailsPresentationLogic
    
    init (presenter: AlarmDetailsPresentationLogic) {
        self.presenter = presenter
    }
    
}
