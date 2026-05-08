final class  CreateNewEventPresenter :  CreateNewEventPresentationLogic  {
   
    typealias Model = CreateNewEventModel
    
    weak var view: CreateNewEventViewController?
    
    func presentEvent(_ request: Model.LoadCreateNewEvent.Response) {
        view?.eventSaved(Model.LoadCreateNewEvent.ViewModel(success: request.success, errorMessage: request.errorMessage))
    }
    
    func presentUpdateEvent(_ response: CreateNewEventModel.LoadUpdateEvent.Response) {
        view?.eventUpdated(Model.LoadUpdateEvent.ViewModel(success: response.success, message: response.message))
    }
}
