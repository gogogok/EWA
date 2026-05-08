import Foundation

protocol MyAlarmsBusinessLogic {
    typealias Model = MyAlarmsModel
    
    func loadUserCreatedAlarms(_ request: Model.LoadAlarms.Request)
    
    func loadUserPartAlarms(_ request: Model.LoadAlarms.Request)
    
    func leaveAlarm(_ request: Model.LoadLeaveAlarms.Request)
    
    func deleteAlarm(_ request: Model.LoadDeleteAlarms.Request)
}

protocol MyAlarmsPresentationLogic: AnyObject {
    typealias Model = MyAlarmsModel

    var view:  MyAlarmsViewController? {get set}
    
    func presentUserCrestedAlarms(_ response: Model.LoadAlarms.Response)
    
    func presentUserPartAlarms(_ response: Model.LoadAlarms.Response)
    
    func presentLeaveAlarm(_ response: Model.LoadLeaveAlarms.Response)
    
    func presentDeleteAlarm(_ response: Model.LoadDeleteAlarms.Response)
}


