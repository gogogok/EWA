import Foundation

protocol MyEventsBusinessLogic {
    typealias Model = MyEventsModel
}

protocol MyEventsPresentationLogic: AnyObject {
    typealias Model = MyEventsModel

    var view:  MyEventsViewController? {get set}
}


