import UIKit

final class  CreateNewEventModel {
    
    enum LoadCreateNewEvent {
        struct Request {
            var eventRequest: EventResponse
        }
        struct Response {
            let success: Bool
            let errorMessage: String
        }
        struct ViewModel {
            let success: Bool
            let errorMessage: String
        }
    }
    
    enum LoadUpdateEvent {
        struct Request {
            var eventRequest: EventResponse
        }
        struct Response {
            let success: Bool
            let message: String
        }
        struct ViewModel {
            let success: Bool
            let message: String
        }
    }

}
