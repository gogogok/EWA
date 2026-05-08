import Foundation

final class AlarmFirstMainScreenInteractor : AlarmFirstMainScreenBusinessLogic{
    
    typealias Model = AlarmFirstMainScreenModel
    
    var presenter: AlarmFirstMainScreenPresentationLogic
    var alarmClient = AlarmApiClient.shared
    
    init (presenter: AlarmFirstMainScreenPresentationLogic) {
        self.presenter = presenter
    }
    
    func loadAlarms(_ request: Model.LoadAlarmMainScreen.Request) {
        Task {
            do {
                let response = try await alarmClient.fetchAvailableAlarms(page: request.page, size: request.limit, type: request.type)
                presenter.presentAlarms(
                    Model.LoadAlarmMainScreen.Response(
                        alarms: response.content,
                        page: response.page,
                        last: response.last,
                        errorMessage: nil
                    )
                )
            } catch {
                presenter.presentAlarms(
                    Model.LoadAlarmMainScreen.Response(
                        alarms: [],
                        page: request.page,
                        last: true,
                        errorMessage: error.localizedDescription
                    )
                )
            }
        }
    }
    
    func registarUser(_ request: Model.RegisterUserToAlarm.Request) {
        Task {
            do {
                let alarm = try await  alarmClient.addAlarmRegistration(alarmId: request.alarmId, userId: request.userId)
                
                try await AppAlarmKitManager.shared.scheduleAlarm(from: alarm)
                
                presenter.presentRegisterUser(Model.RegisterUserToAlarm.Response(success: true, message: "Вы часть будильникао!"))
                
            } catch {
                presenter.presentRegisterUser(Model.RegisterUserToAlarm.Response(success: false, message: "Произошла ошибка, попробуйте позже ещё раз"))
            }
        }
    }
    
}
