//
//  SetIconProtocols.swift
//  EWA
//
//  Created by Дарья Жданок on 13.02.26.
//

import UIKit


protocol SetIconBusinessLogic {
    typealias Model = SetIconsModel
    
    func loadMainScreen(_ request: Model.LoadSetIconsModel.Request)
}

protocol SetIconPresentationLogic {
    typealias Model = SetIconsModel
    
    var userViewIcons: ProfileIconChooseScreenController? {get set}
    
    func presentMainScreen(_ response: Model.LoadSetIconsModel.Response)
}

