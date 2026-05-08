import Foundation

protocol ParticipantsBusinessLogic {
    typealias Model = ParticipantsModel
    
    func addToBlackList(_ request: Model.LoadAddBlackList.Request)
}

protocol ParticipantsPresentationLogic: AnyObject {
    typealias Model = ParticipantsModel

    var view:  ParticipantsViewController? {get set}
    
    func presentAddToBlackList(_ response: Model.LoadAddBlackList.Response)
}


