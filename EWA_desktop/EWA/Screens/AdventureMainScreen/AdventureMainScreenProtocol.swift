import Foundation

protocol AdventureMainScreenBusinessLogic {
    typealias Model = AdventureMainScreenModel
}

protocol AdventureMainScreenPresentationLogic: AnyObject {
    typealias Model = AdventureMainScreenModel

    var view:  AdventureMainScreenViewController? {get set}
}


