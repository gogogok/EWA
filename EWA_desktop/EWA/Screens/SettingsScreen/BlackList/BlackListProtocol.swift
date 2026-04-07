import Foundation

protocol BlackListBusinessLogic {
    typealias Model = BlackListModel
}

protocol BlackListPresentationLogic: AnyObject {
    typealias Model = BlackListModel

    var view:  BlackListViewController? {get set}
}


