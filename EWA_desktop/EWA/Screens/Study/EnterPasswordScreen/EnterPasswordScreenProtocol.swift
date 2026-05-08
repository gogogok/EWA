import Foundation

protocol EnterPasswordScreenBusinessLogic {
    typealias Model = EnterPasswordScreenModel
}

protocol EnterPasswordScreenPresentationLogic: AnyObject {
    typealias Model = EnterPasswordScreenModel

    var view:  EnterPasswordScreenViewController? {get set}
}


