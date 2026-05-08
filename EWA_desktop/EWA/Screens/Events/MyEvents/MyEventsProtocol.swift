import Foundation

protocol MyEventsBusinessLogic {
    typealias Model = MyEventsModel
    
    func loadUserCrestedEvents(_ request: Model.LoadEvents.Request)
    
    func loadUserPartEvents(_ request: Model.LoadEvents.Request)
    
    func leaveEvent(_ request: Model.LoadLeaveEvents.Request)
    
    func deleteEvent(_ request: Model.LoadDeleteEvents.Request)
}

protocol MyEventsPresentationLogic: AnyObject {
    typealias Model = MyEventsModel

    var view:  MyEventsViewController? {get set}
    
    func presentUserCrestedEvents(_ response: Model.LoadEvents.Response)
    
    func presentUserPartEvents(_ response: Model.LoadEvents.Response)
    
    func presentLeaveEvent(_ request: Model.LoadLeaveEvents.Response)
    
    func presentDeleteEvent(_ request: Model.LoadDeleteEvents.Response)
}


