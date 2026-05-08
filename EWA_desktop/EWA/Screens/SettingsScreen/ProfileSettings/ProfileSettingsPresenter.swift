final class  ProfileSettingsPresenter :  ProfileSettingsPresentationLogic  {
    
    typealias Model = ProfileSettingsModel
    
    weak var view: ProfileSettingsViewController?
    
    func presentMainScreen(_ response: Model.LoadProfileSettings.Response) {
        view?.displayMainScreen(Model.LoadProfileSettings.ViewModel(viewController: response.viewController, indexChosen: 0))
    }
    
}
