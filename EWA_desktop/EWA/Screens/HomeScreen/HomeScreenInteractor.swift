//
//  HomeScreenProtocols.swift
//  EWA
//
//  Created by Дарья Жданок on 13.02.26.
//

final class HomeScreenInteractor : HomeScreenBusinessLogic{
    
    var presenter: HomeScreenPresentationLogic
    
    init (presenter: HomeScreenPresentationLogic) {
        self.presenter = presenter
    }
    
}
