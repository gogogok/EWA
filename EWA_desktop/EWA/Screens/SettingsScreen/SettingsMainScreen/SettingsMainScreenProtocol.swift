import Foundation

protocol SettingsMainScreenBusinessLogic {
    typealias Model = SettingsMainScreenModel
}

protocol SettingsMainScreenPresentationLogic: AnyObject {
    typealias Model = SettingsMainScreenModel

    var view:  SettingsMainScreenViewController? {get set}
}


