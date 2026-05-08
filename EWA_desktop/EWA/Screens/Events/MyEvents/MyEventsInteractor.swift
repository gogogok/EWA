import Foundation

final class MyEventsInteractor : MyEventsBusinessLogic{
    
    var presenter: MyEventsPresentationLogic
    let eventsApiClient = EventsApClient.shared
    
    init (presenter: MyEventsPresentationLogic) {
        self.presenter = presenter
    }
    
    func loadUserCrestedEvents(_ request: Model.LoadEvents.Request) {
        Task{
            do{
                guard let userId = UserDefaults.standard.string(forKey: UserDefaultsKeys.id) else {return}
                let events = try await eventsApiClient.getCreatedEventsByUserId(userId: userId)
                presenter.presentUserCrestedEvents(Model.LoadEvents.Response(events: events))
            }
        }
    }
    
    func loadUserPartEvents(_ request: Model.LoadEvents.Request) {
        Task{
            do{
                guard let userId = UserDefaults.standard.string(forKey: UserDefaultsKeys.id) else {return}
                let events = try await eventsApiClient.getRegisteredEventsByUserId(userId: userId)
                presenter.presentUserPartEvents(Model.LoadEvents.Response(events: events))
            }
        }
    }
    
    func leaveEvent(_ request: Model.LoadLeaveEvents.Request) {
        Task{
            do{
                guard let userId = UserDefaults.standard.string(forKey: UserDefaultsKeys.id) else {return}
                let response = try await eventsApiClient.leaveEvent(eventId: request.eventId, userId: userId)
                print(response)
                presenter.presentLeaveEvent(MyEventsModel.LoadLeaveEvents.Response(success: true, message: nil, eventId: request.eventId))
            } catch {
                presenter.presentLeaveEvent(MyEventsModel.LoadLeaveEvents.Response(success: false, message: "Не удалось совершить операцию, повторите попытку позже!", eventId: request.eventId))
            }
        }
    }
    
    func deleteEvent(_ request: Model.LoadDeleteEvents.Request) {
        Task{
            do{
                let response = try await eventsApiClient.deleteEvent(eventId: request.eventId)
                print(response)
                presenter.presentDeleteEvent(MyEventsModel.LoadDeleteEvents.Response(success: true, message: "Мероприятие удалено", eventId: request.eventId))
            } catch {
                presenter.presentDeleteEvent(MyEventsModel.LoadDeleteEvents.Response(success: false, message: "Не удалось совершить операцию, повторите попытку позже!", eventId: request.eventId))
            }
        }
    }
    
}
