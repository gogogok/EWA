import Foundation

protocol CreateNewRoomBusinessLogic {
    typealias Model = CreateNewRoomModel
    
    func saveRoom(_ request: Model.LoadCreateNewStudeRoom.Request)
}

protocol CreateNewRoomPresentationLogic: AnyObject {
    typealias Model = CreateNewRoomModel

    var view:  CreateNewRoomViewController? {get set}
    
    func presentRoom(_ response: Model.LoadCreateNewStudeRoom.Response)
}


