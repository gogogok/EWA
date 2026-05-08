import Foundation

final class AdventureMainScreenInteractor : AdventureMainScreenBusinessLogic{
   
    var presenter: AdventureMainScreenPresentationLogic
    var eventClient = EventsApClient.shared
    
    init (presenter: AdventureMainScreenPresentationLogic) {
        self.presenter = presenter
    }
    
    func loadEvents(_ request: AdventureMainScreenModel.LoadAdventureMainScreen.Request) {
        Task {
            do {
                let response = try await eventClient.fetchAvailableEvents(page: request.page, size: request.limit)
                presenter.presentEvents(
                    Model.LoadAdventureMainScreen.Response(
                        events: response.content,
                        page: response.page,
                        last: response.last,
                        errorMessage: nil
                    )
                )
            } catch {
                presenter.presentEvents(
                    Model.LoadAdventureMainScreen.Response(
                        events: [],
                        page: request.page,
                        last: true,
                        errorMessage: error.localizedDescription
                    )
                )
            }
        }
    }
    
    func registarUser(_ request: AdventureMainScreenModel.RegisterUserToEvent.Request) {
        Task {
            do {
                guard let userId = UserDefaults.standard.string(forKey: UserDefaultsKeys.id) else {return}
                let response = try await eventClient.addEventRegistration(eventId: request.eventId, userId: userId)
                presenter.presentRegisterUser(
                    AdventureMainScreenModel.RegisterUserToEvent.Response(success: true, message: "Регистрация прошла успешно"))
            } catch {
                presenter.presentRegisterUser(
                    AdventureMainScreenModel.RegisterUserToEvent.Response(success: false, message: "Не удалось совершить операцию"
                    )
                )
            }
        }
    }
}
