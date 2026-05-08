import Foundation

final class CreateNewEventInteractor : CreateNewEventBusinessLogic{
    
    
    var presenter: CreateNewEventPresentationLogic
    let eventClient = EventsApClient.shared
    
    init (presenter: CreateNewEventPresentationLogic) {
        self.presenter = presenter
    }
    
    func saveEvent(_ request: Model.LoadCreateNewEvent.Request) {
        Task {
            do {
                let result = try await eventClient.addEventToDataBase(event: request.eventRequest)
                print(result)
                
                presenter.presentEvent(
                    Model.LoadCreateNewEvent.Response(
                        success: true,
                        errorMessage: "Мероприятие сохранено!"
                    )
                )
                
            } catch {
                presenter.presentEvent(
                    Model.LoadCreateNewEvent.Response(
                        success: false,
                        errorMessage: error.localizedDescription
                    )
                )
            }
        }
    }
    
    func updateEvent(_ request: CreateNewEventModel.LoadUpdateEvent.Request) {
        Task {
            do {
                let result = try await eventClient.editEvent(event: request.eventRequest)
                print(result)
                
                presenter.presentUpdateEvent(
                    Model.LoadUpdateEvent.Response(
                        success: true,
                        message: "Мероприятие успешно обновлено!"
                    )
                )
                
            } catch {
                presenter.presentUpdateEvent(
                    Model.LoadUpdateEvent.Response(
                        success: false,
                        message: error.localizedDescription
                    )
                )
            }
        }
    }
    
}
