//
//  SetIconProtocols.swift
//  EWA
//
//  Created by Дарья Жданок on 13.02.26.
//

import FirebaseAuth

final class SetIconInteractor : SetIconBusinessLogic{
    
    var presenter: SetIconPresentationLogic
    let userWorker = UserProfileManager()
    
    init (presenter: SetIconPresentationLogic) {
        self.presenter = presenter
    }
    
    func loadMainScreen(_ request: Model.StartMainScreen.Request) {
        let uid = Auth.auth().currentUser!.uid
        userWorker.updateIcon(id: uid, iconName: request.iconName)
        presenter.presentMainScreen(Model.StartMainScreen.Response(viewController: request.viewController))
    }}
