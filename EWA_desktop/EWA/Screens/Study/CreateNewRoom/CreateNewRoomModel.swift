import UIKit

final class  CreateNewRoomModel {
    
    enum LoadCreateNewStudeRoom {
        struct Request {
            var roomRequest: StudyResponse
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

}
