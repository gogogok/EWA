final class  MyEventsPresenter :  MyEventsPresentationLogic  {
    
    typealias Model = MyEventsModel
    
    weak var view: MyEventsViewController?
    
    func presentUserCrestedEvents(_ response: Model.LoadEvents.Response) {
        view?.loadCreateData(Model.LoadEvents.ViewModel(events: response.events))
    }
    
    func presentUserPartEvents(_ response: Model.LoadEvents.Response) {
        view?.loadPartData(Model.LoadEvents.ViewModel(events: response.events))
    }
    
    func presentLeaveEvent(_ request: Model.LoadLeaveEvents.Response) {
        view?.eventLeft(Model.LoadLeaveEvents.ViewModel(success: request.success, message: request.message, eventId: request.eventId))
    }
    
    func presentDeleteEvent(_ request: Model.LoadDeleteEvents.Response) {
        view?.eventDelete(Model.LoadDeleteEvents.ViewModel(success: request.success, message: request.message, eventId: request.eventId))
    }
}
