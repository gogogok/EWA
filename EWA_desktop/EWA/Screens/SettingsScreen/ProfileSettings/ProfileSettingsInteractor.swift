import FirebaseAuth

final class ProfileSettingsInteractor : ProfileSettingsBusinessLogic{
    
    var presenter: ProfileSettingsPresentationLogic
    let userService = UserApiClient.shared
    
    init (presenter: ProfileSettingsPresentationLogic) {
        self.presenter = presenter
    }
    
    func loadMainScreen(_ request: Model.LoadProfileSettings.Request) {
        let uid = Auth.auth().currentUser!.uid
        UserDefaults.standard.set(request.iconName, forKey: UserDefaultsKeys.iconName)
        UserDefaults.standard.set(request.name, forKey: UserDefaultsKeys.username)
        
        Task {
            do {
                let user = try await userService.getUserById(id: uid)
                
                try await print(userService.updateUserAtBase(user: UserResponse(id: uid, name: request.name, email: user.email, iconName: request.iconName)))
                
                
                presenter.presentMainScreen(Model.LoadProfileSettings.Response(viewController: request.viewController, indexChosen: request.indexChosen))
            }
        }
                
    }
}
