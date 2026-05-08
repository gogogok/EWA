import UIKit

final class  StudyMainScreenModel {
    
    enum LoadStudyMainScreen {
        struct Request {
            var page: Int
            var limit: Int
        }
        struct Response {
            var rooms: [StudyResponse]
            var page: Int
            var last: Bool
            var errorMessage : String?
        }
        struct ViewModel {
            var items: [StudyCardView.Model]
            var page: Int
            var last: Bool
            var errorMessage : String?
            var rooms: [StudyResponse]
        }
    }
    
    enum LoadEnterPassword {
        struct Request {
            var room: StudyResponse
            var type: String
            var password: String?
        }
        struct Response {
            var room: StudyResponse
            var type: String
            var password: String?
        }
        struct ViewModel {
            var room: StudyResponse
            var type: String
            var password: String?
        }
    }

    enum LoadERegistration {
        struct Request {
            var room: StudyResponse
            
        }
        struct Response {
            var room: StudyResponse
           
        }
        struct ViewModel {
            var room: StudyResponse
           
        }
    }
}
