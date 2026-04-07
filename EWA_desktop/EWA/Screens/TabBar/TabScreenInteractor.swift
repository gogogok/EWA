//
//  TabScreenProtocols.swift
//  EWA
//
//  Created by Дарья Жданок on 13.02.26.
//

final class TabScreenInteractor : TabScreenBusinessLogic{
    
    var presenter: TabScreenPresentationLogic
    
    init (presenter: TabScreenPresentationLogic) {
        self.presenter = presenter
    }
    
}
