//
//  SetIconProtocols.swift
//  EWA
//
//  Created by Дарья Жданок on 13.02.26.
//

import FirebaseAuth

final class SetIconInteractor : SetIconBusinessLogic{
    
    var presenter: SetIconPresentationLogic
    let userService = UserApiClient.shared
    
    init (presenter: SetIconPresentationLogic) {
        self.presenter = presenter
    }
    
    func loadMainScreen(_ request: Model.LoadSetIconsModel.Request) {
        Task {
            var draft = request.draft
            draft.iconName = request.iconName
            
            let uid = draft.id ?? Auth.auth().currentUser!.uid
            let name = draft.name ?? ""
            let email = draft.email ?? ""
            
            UserDefaults.standard.set(request.iconName, forKey: UserDefaultsKeys.iconName)
            let userDto = UserResponse(id: uid, name: name, email: email, iconName: request.iconName)
            do {
                try await print(userService.addUserToDataBase(user: userDto).status)
                presenter.presentMainScreen(Model.LoadSetIconsModel.Response(viewController: request.viewController, indexChosen: request.indexChosen))
            } catch {
                print(error)
            }
        }
        
    }
    
    func loadMainScreenAfterEdit(_ request: Model.LoadSetIconsModel.Request) {
        Task {
            var draft = request.draft
            draft.iconName = request.iconName
            
            let uid = draft.id ?? Auth.auth().currentUser!.uid
            let name = draft.name ?? ""
            let email = draft.email ?? ""
            
            UserDefaults.standard.set(request.iconName, forKey: UserDefaultsKeys.iconName)
            let userDto = UserResponse(id: uid, name: name, email: email, iconName: request.iconName)
            do {
                try await print(userService.updateUserAtBase(user: userDto).status)
                presenter.presentMainScreen(Model.LoadSetIconsModel.Response(viewController: request.viewController, indexChosen: request.indexChosen))
            } catch {
                print(error)
            }
        }
    }
}
