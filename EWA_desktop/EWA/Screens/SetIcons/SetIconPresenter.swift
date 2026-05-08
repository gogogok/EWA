//
//  SetIconProtocols.swift
//  EWA
//
//  Created by Дарья Жданок on 13.02.26.
//

final class SetIconPresenter : SetIconPresentationLogic  {
    typealias Model = SetIconsModel
    
    var userViewIcons: ProfileIconChooseScreenController?
    
    func presentMainScreen(_ response: Model.LoadSetIconsModel.Response) {
        userViewIcons?.displayMainScreen(Model.LoadSetIconsModel.ViewModel(indexChosen: response.indexChosen, viewController: response.viewController))
    }
    
}
