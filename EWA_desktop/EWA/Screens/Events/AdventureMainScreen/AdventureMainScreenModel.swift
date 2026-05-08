import UIKit

final class  AdventureMainScreenModel {
    
    enum LoadAdventureMainScreen {
        struct Request {
            var page: Int
            var limit: Int
        }
        struct Response {
            var events: [EventResponse]
            var page: Int
            var last: Bool
            var errorMessage : String?
        }
        struct ViewModel {
            var items: [AdventureCardView.Model]
            var page: Int
            var last: Bool
            var errorMessage : String?
            var events: [EventResponse]
        }
    }

    enum RegisterUserToEvent {
        struct Request {
            let eventId: String
            let userId: String?
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
