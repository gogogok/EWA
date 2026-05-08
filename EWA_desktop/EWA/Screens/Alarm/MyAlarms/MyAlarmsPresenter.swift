final class  MyAlarmsPresenter :  MyAlarmsPresentationLogic  {
    
    typealias Model = MyAlarmsModel
    
    weak var view: MyAlarmsViewController?
    
    func presentUserCrestedAlarms(_ response: Model.LoadAlarms.Response) {
        view?.loadCreateData(Model.LoadAlarms.ViewModel(alarms: response.alarms))
    }
    
    func presentUserPartAlarms(_ response: Model.LoadAlarms.Response) {
        view?.loadPartData(Model.LoadAlarms.ViewModel(alarms: response.alarms))
    }
    
    func presentLeaveAlarm(_ response: Model.LoadLeaveAlarms.Response) {
        view?.alarmtLeft(Model.LoadLeaveAlarms.ViewModel(success: response.success, message: response.message, alarmId: response.alarmId))
    }
    
    func presentDeleteAlarm(_ response: Model.LoadDeleteAlarms.Response) {
        view?.alarmDelete(Model.LoadDeleteAlarms.ViewModel(success: response.success, message: response.message, alarmId: response.alarmId))
    }
    
    
}
