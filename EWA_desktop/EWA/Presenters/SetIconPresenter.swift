//
//  SetIconProtocols.swift
//  EWA
//
//  Created by Дарья Жданок on 13.02.26.
//

final class SetIconPresenter : SetIconPresentationLogic  {
    typealias Model = EWAModel
    
    var userViewIcons: ProfileIconChooseScreenController?
    
    func presentMainScreen(_ response: Model.StartMainScreen.Response) {
        userViewIcons?.displayMainScreen(Model.StartMainScreen.ViewModel(viewController: response.viewController))
    }
    
}
