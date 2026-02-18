//
//  HomeScreenProtocols.swift
//  EWA
//
//  Created by Дарья Жданок on 13.02.26.
//

import UIKit


protocol HomeScreenBusinessLogic {
    typealias Model = EWAModel
    
}

protocol HomeScreenPresentationLogic {
    
    var homeScreenView: HomeScreenViewController? {get set}
    
    typealias Model = EWAModel
}
