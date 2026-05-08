import UIKit

final class  CreateNewAlarmModel {
    
    enum LoadCreateNewAlarm {
        struct Request {
            var alarmRequest: AlarmResponse
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
    
    enum LoadUpdateAlarm {
        struct Request {
            var alarmRequest: AlarmResponse
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
