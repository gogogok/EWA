import UIKit

final class  MyEventsModel {
    
    enum LoadEvents {
        struct Request {}
        struct Response {
            var events: [EventResponse]?
        }
        struct ViewModel {
            var events: [EventResponse]?
        }
    }
    
    enum LoadLeaveEvents {
        struct Request {
            let eventId: String
        }
        struct Response {
            var success: Bool
            var message: String?
            let eventId: String
        }
        struct ViewModel {
            var success: Bool
            var message: String?
            let eventId: String
        }
    }
    
    enum LoadDeleteEvents {
        struct Request {
            let eventId: String
        }
        struct Response {
            var success: Bool
            var message: String?
            let eventId: String
        }
        struct ViewModel {
            var success: Bool
            var message: String?
            let eventId: String
        }
    }

}
