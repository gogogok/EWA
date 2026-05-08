import UIKit

final class  BlackListModel {
    
    enum DeleteFromBlackList {
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
