final class ShowMoreEventsInteractor : ShowMoreEventsBusinessLogic{
    
    var presenter: ShowMoreEventsPresentationLogic
    
    init (presenter: ShowMoreEventsPresentationLogic) {
        self.presenter = presenter
    }
    
    func fetchEvent(id: String?) {
        guard let id = id else { return }
        Task{
            do {
                let event = try await EventsApClient.shared.getEventById(id: id)
                
                await MainActor.run {
                    presenter.presentEvent(event)
                }
            } catch {
                print("Error: ", error)
            }
        }
    }
}
