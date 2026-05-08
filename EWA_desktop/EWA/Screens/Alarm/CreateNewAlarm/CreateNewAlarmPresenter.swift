final class  CreateNewAlarmPresenter :  CreateNewAlarmPresentationLogic  {
    
    typealias Model = CreateNewAlarmModel
    
    weak var view: CreateNewAlarmViewController?
    
    func presentAlarm(_ response: Model.LoadCreateNewAlarm.Response) {
        view?.alarmSaved(Model.LoadCreateNewAlarm.ViewModel(success: response.success, errorMessage: response.errorMessage))
    }
    
    func presentUpdateAlarm(_ response: Model.LoadUpdateAlarm.Response) {
        view?.alarmUpdated(Model.LoadUpdateAlarm.ViewModel(success: response.success, message: response.message))
    }
}
