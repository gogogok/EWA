import Foundation

protocol BlackListBusinessLogic {
    typealias Model = BlackListModel
    
    func deleteFromBlackList(_ request: Model.DeleteFromBlackList.Request)
}

protocol BlackListPresentationLogic: AnyObject {
    typealias Model = BlackListModel

    var view:  BlackListViewController? {get set}
    
    func presentDeleteFromBlacklackList(_ response: Model.DeleteFromBlackList.Response)
}


