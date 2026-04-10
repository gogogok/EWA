import Foundation

protocol ShowMoreEventsBusinessLogic {
    typealias Model = ShowMoreEventsModel
}

protocol ShowMoreEventsPresentationLogic: AnyObject {
    typealias Model = ShowMoreEventsModel

    var view:  ShowMoreEventsViewController? {get set}
}


