import Foundation

protocol AdventureMainScreenBusinessLogic {
    typealias Model = AdventureMainScreenModel
    
    func loadEvents(_ request: Model.LoadAdventureMainScreen.Request)
    
    func registarUser(_ request: Model.RegisterUserToEvent.Request)
}

protocol AdventureMainScreenPresentationLogic: AnyObject {
    typealias Model = AdventureMainScreenModel

    var view:  AdventureMainScreenViewController? {get set}
    
    func presentEvents(_ response: Model.LoadAdventureMainScreen.Response)
    
    func presentRegisterUser(_ response: Model.RegisterUserToEvent.Response)
}


