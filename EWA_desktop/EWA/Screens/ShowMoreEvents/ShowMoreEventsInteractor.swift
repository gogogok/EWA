final class ShowMoreEventsInteractor : ShowMoreEventsBusinessLogic{
    
    var presenter: ShowMoreEventsPresentationLogic
    
    init (presenter: ShowMoreEventsPresentationLogic) {
        self.presenter = presenter
    }
    
}
