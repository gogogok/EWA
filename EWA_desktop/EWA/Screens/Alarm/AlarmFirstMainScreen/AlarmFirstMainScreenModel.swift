import UIKit

final class  AlarmFirstMainScreenModel {
    
    enum LoadAlarmMainScreen {
        struct Request {
            var page: Int
            var limit: Int
            var type: String
        }
        struct Response {
            var alarms: [AlarmResponse]
            var page: Int
            var last: Bool
            var errorMessage : String?
        }
        struct ViewModel {
            var items: [AlarmCardView.Model]
            var page: Int
            var last: Bool
            var errorMessage : String?
            var alarms: [AlarmResponse]
        }
    }

    enum RegisterUserToAlarm {
        struct Request {
            let alarmId: String
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
