import FirebaseAuth

final class ProfileSettingsInteractor : ProfileSettingsBusinessLogic{
    
    var presenter: ProfileSettingsPresentationLogic
    let userWorker = UserProfileManager()
    
    init (presenter: ProfileSettingsPresentationLogic) {
        self.presenter = presenter
    }
    
    func loadMainScreen(_ request: Model.LoadProfileSettings.Request) {
        let uid = Auth.auth().currentUser!.uid
        userWorker.updateIcon(id: uid, iconName: request.iconName)
        userWorker.updateName(id: uid, name: request.name)
        presenter.presentMainScreen(Model.LoadProfileSettings.Response(viewController: request.viewController, indexChosen: request.indexChosen))
    }
}
