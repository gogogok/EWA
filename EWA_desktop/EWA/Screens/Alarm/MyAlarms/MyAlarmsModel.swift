import UIKit

final class  MyAlarmsModel {
    
    enum LoadAlarms {
        struct Request {}
        struct Response {
            var alarms: [AlarmResponse]?
        }
        struct ViewModel {
            var alarms: [AlarmResponse]?
        }
    }
    
    enum LoadLeaveAlarms {
        struct Request {
            let alarmId: String
        }
        struct Response {
            var success: Bool
            var message: String?
            let alarmId: String
        }
        struct ViewModel {
            var success: Bool
            var message: String?
            let alarmId: String
        }
    }
    
    enum LoadDeleteAlarms {
        struct Request {
            let alarmId: String
        }
        struct Response {
            var success: Bool
            var message: String?
            let alarmId: String
        }
        struct ViewModel {
            var success: Bool
            var message: String?
            let alarmId: String
        }
    }

}
