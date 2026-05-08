import Foundation

protocol AlarmFirstMainScreenBusinessLogic {
    typealias Model = AlarmFirstMainScreenModel
    
    func loadAlarms(_ request: Model.LoadAlarmMainScreen.Request)
    
    func registarUser(_ request: Model.RegisterUserToAlarm.Request)
}

protocol AlarmFirstMainScreenPresentationLogic: AnyObject {
    typealias Model = AlarmFirstMainScreenModel

    var view:  AlarmFirstMainScreenViewController? {get set}
    
    func presentAlarms(_ response: Model.LoadAlarmMainScreen.Response)
    
    func presentRegisterUser(_ response: Model.RegisterUserToAlarm.Response)
}


