//
//  SetIconProtocols.swift
//  EWA
//
//  Created by Дарья Жданок on 13.02.26.
//

import UIKit


protocol SetIconBusinessLogic {
    typealias Model = EWAModel
    
    func loadMainScreen(_ request: Model.StartMainScreen.Request)
}

protocol SetIconPresentationLogic {
    typealias Model = EWAModel
    
    var userViewIcons: ProfileIconChooseScreenController? {get set}
    
    func presentMainScreen(_ response: Model.StartMainScreen.Response)
}

