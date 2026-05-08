final class StudyRoomInteractor : StudyRoomBusinessLogic{
    
    var presenter: StudyRoomPresentationLogic
    
    init (presenter: StudyRoomPresentationLogic) {
        self.presenter = presenter
    }
    
}
