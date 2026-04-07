final class SettingsMainScreenInteractor : SettingsMainScreenBusinessLogic{
    
    var presenter: SettingsMainScreenPresentationLogic
    
    init (presenter: SettingsMainScreenPresentationLogic) {
        self.presenter = presenter
    }
    
}
