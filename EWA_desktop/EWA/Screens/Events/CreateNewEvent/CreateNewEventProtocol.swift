import Foundation

protocol CreateNewEventBusinessLogic {
    typealias Model = CreateNewEventModel
    
    func saveEvent(_ request: Model.LoadCreateNewEvent.Request)
    
    func updateEvent(_ request: CreateNewEventModel.LoadUpdateEvent.Request)
}

protocol CreateNewEventPresentationLogic: AnyObject {
    typealias Model = CreateNewEventModel

    var view:  CreateNewEventViewController? {get set}
    
    func presentEvent(_ request: Model.LoadCreateNewEvent.Response)
    
    func presentUpdateEvent(_ response: CreateNewEventModel.LoadUpdateEvent.Response)
}


