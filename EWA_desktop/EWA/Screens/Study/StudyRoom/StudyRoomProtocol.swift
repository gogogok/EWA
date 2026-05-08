import Foundation

protocol StudyRoomBusinessLogic {
    typealias Model = StudyRoomModel
}

protocol StudyRoomPresentationLogic: AnyObject {
    typealias Model = StudyRoomModel

    var view:  StudyRoomViewController? {get set}
}


