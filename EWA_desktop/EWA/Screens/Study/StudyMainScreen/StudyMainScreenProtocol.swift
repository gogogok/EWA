import Foundation

protocol StudyMainScreenBusinessLogic {
    typealias Model = StudyMainScreenModel
    
    func loadRooms(_ request: Model.LoadStudyMainScreen.Request)
    
    func openPasswordPanel(_ request: Model.LoadEnterPassword.Request)
    
    func registerParticipant(_ request: Model.LoadERegistration.Request)
}

protocol StudyMainScreenPresentationLogic: AnyObject {
    typealias Model = StudyMainScreenModel

    var view:  StudyMainScreenViewController? {get set}
    
    func presentRooms(_ response: Model.LoadStudyMainScreen.Response)
    
    func presentPasswordPanel(_ response: Model.LoadEnterPassword.Response)
}


