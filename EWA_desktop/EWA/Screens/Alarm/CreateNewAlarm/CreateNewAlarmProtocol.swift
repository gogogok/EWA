import Foundation

protocol CreateNewAlarmBusinessLogic {
    typealias Model = CreateNewAlarmModel
    
    func saveAlarm(_ request: Model.LoadCreateNewAlarm.Request)
    
    func updateAlarm(_ request: Model.LoadUpdateAlarm.Request)
}

protocol CreateNewAlarmPresentationLogic: AnyObject {
    typealias Model = CreateNewAlarmModel

    var view:  CreateNewAlarmViewController? {get set}
    
    func presentAlarm(_ response: Model.LoadCreateNewAlarm.Response)
    
    func presentUpdateAlarm(_ response: Model.LoadUpdateAlarm.Response)
}


