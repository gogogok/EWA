import Foundation

final class MyAlarmsInteractor : MyAlarmsBusinessLogic{
    
    var presenter: MyAlarmsPresentationLogic
    let alarmApiClient = AlarmApiClient.shared
    
    init (presenter: MyAlarmsPresentationLogic) {
        self.presenter = presenter
    }
    
    func loadUserCreatedAlarms(_ request: Model.LoadAlarms.Request) {
        Task{
            do{
                guard let userId = UserDefaults.standard.string(forKey: UserDefaultsKeys.id) else {return}
                let alarms = try await alarmApiClient.getCreatedEAlarmsByUserId(userId: userId)
                presenter.presentUserCrestedAlarms(Model.LoadAlarms.Response(alarms: alarms))
            }
        }
    }
    
    func loadUserPartAlarms(_ request: Model.LoadAlarms.Request) {
        Task{
            do{
                guard let userId = UserDefaults.standard.string(forKey: UserDefaultsKeys.id) else {return}
                let alarms = try await alarmApiClient.getRegisteredAlarmsByUserId(userId: userId)
                presenter.presentUserPartAlarms(Model.LoadAlarms.Response(alarms: alarms))
            }
        }
    }
    
    func leaveAlarm(_ request: Model.LoadLeaveAlarms.Request) {
        Task{
            do{
                guard let userId = UserDefaults.standard.string(forKey: UserDefaultsKeys.id) else {return}
                let response = try await alarmApiClient.leaveAlarm(alarmId: request.alarmId, userId: userId)
                print(response)
                presenter.presentLeaveAlarm(Model.LoadLeaveAlarms.Response(success: true, message: nil, alarmId: request.alarmId))
            } catch {
                presenter.presentLeaveAlarm(Model.LoadLeaveAlarms.Response(success: false, message: "Не удалось совершить операцию, повторите попытку позже!", alarmId: request.alarmId))
            }
        }
    }
    
    func deleteAlarm(_ request: Model.LoadDeleteAlarms.Request) {
        Task{
            do{
                let response = try await alarmApiClient.deleteAlarm(alarmId: request.alarmId)
                print(response)
                presenter.presentDeleteAlarm(Model.LoadDeleteAlarms.Response(success: true, message: "Мероприятие удалено", alarmId: request.alarmId))
            } catch {
                presenter.presentDeleteAlarm(Model.LoadDeleteAlarms.Response(success: false, message: "Не удалось совершить операцию, повторите попытку позже!", alarmId: request.alarmId))
            }
        }
    }
    
}
