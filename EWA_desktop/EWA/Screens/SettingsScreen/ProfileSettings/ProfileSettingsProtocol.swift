import Foundation

protocol ProfileSettingsBusinessLogic {
    typealias Model = ProfileSettingsModel
    
    func loadMainScreen(_ request: Model.LoadProfileSettings.Request)
}

protocol ProfileSettingsPresentationLogic: AnyObject {
    typealias Model = ProfileSettingsModel

    var view:  ProfileSettingsViewController? {get set}
    
    func presentMainScreen(_ response: Model.LoadProfileSettings.Response)
}


