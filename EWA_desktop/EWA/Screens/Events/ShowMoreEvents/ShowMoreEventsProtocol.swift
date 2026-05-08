import Foundation

protocol ShowMoreEventsBusinessLogic {
    typealias Model = ShowMoreEventsModel
    
    func fetchEvent(id: String?)
}

protocol ShowMoreEventsPresentationLogic: AnyObject {
    typealias Model = ShowMoreEventsModel

    var view:  ShowMoreEventsViewController? {get set}
    
    func presentEvent(_ event: EventResponse)
}


