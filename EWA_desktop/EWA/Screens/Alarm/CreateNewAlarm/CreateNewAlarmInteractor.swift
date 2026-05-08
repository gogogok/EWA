import Foundation

final class CreateNewAlarmInteractor : CreateNewAlarmBusinessLogic{
   
    var presenter: CreateNewAlarmPresentationLogic
    let alarmClient = AlarmApiClient.shared
    
    init (presenter: CreateNewAlarmPresentationLogic) {
        self.presenter = presenter
    }
    
    func saveAlarm(_ request: Model.LoadCreateNewAlarm.Request) {
        Task {
            do {
                let result = try await alarmClient.addAlarmToDataBase(alarm: request.alarmRequest)
                
                try await AppAlarmKitManager.shared.scheduleAlarm(from: result)
                
                print(result)
                
                presenter.presentAlarm(
                    Model.LoadCreateNewAlarm.Response(
                        success: true,
                        errorMessage: "Будильник сохранён!"
                    )
                )
                
            } catch {
                presenter.presentAlarm(
                    Model.LoadCreateNewAlarm.Response(
                        success: false,
                        errorMessage: error.localizedDescription
                    )
                )
            }
        }
    }
    
    func updateAlarm(_ request: Model.LoadUpdateAlarm.Request) {
        Task {
            do {
                let result = try await alarmClient.editAlarm(alarm: request.alarmRequest)
                print(result)
                
                presenter.presentUpdateAlarm(
                    Model.LoadUpdateAlarm.Response(
                        success: true,
                        message: "Будильник успешно обновлён!"
                    )
                )
                
            } catch {
                presenter.presentUpdateAlarm(
                    Model.LoadUpdateAlarm.Response(
                        success: false,
                        message: error.localizedDescription
                    )
                )
            }
        }
    }
}
