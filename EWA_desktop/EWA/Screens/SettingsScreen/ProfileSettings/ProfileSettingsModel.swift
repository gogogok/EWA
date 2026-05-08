import UIKit

final class  ProfileSettingsModel {
    
    enum LoadProfileSettings {
        struct Request {
            var viewController: UIViewController
            var iconName: String
            var name: String
            var indexChosen: Int
        }
        struct Response {
            var viewController: UIViewController
            var indexChosen: Int
        }
        struct ViewModel {
            var viewController: UIViewController
            var indexChosen: Int
        }
    }
    
}
