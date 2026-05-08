import UIKit

final class  ParticipantsModel {
    
    enum LoadAddBlackList {
        struct Request {
            let userId: String
        }
        struct Response {
            var error: String?
        }
        struct ViewModel {
            var error: String?
        }
    }

}
