final class  ShowMoreEventsPresenter :  ShowMoreEventsPresentationLogic  {
    
    typealias Model = ShowMoreEventsModel
    
    weak var view: ShowMoreEventsViewController?
    
    func presentEvent(_ event: EventResponse) {
        view?.displayEvent(event)
    }
}
