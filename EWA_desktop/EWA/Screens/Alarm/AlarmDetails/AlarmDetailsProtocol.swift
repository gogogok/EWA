import Foundation

protocol AlarmDetailsBusinessLogic {
    typealias Model = AlarmDetailsModel
}

protocol AlarmDetailsPresentationLogic: AnyObject {
    typealias Model = AlarmDetailsModel

    var view:  AlarmDetailsViewController? {get set}
}


