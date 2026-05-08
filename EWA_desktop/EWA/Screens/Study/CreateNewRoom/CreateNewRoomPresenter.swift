final class  CreateNewRoomPresenter :  CreateNewRoomPresentationLogic  {
    
    typealias Model = CreateNewRoomModel
    
    weak var view: CreateNewRoomViewController?
    
    func presentRoom(_ response: Model.LoadCreateNewStudeRoom.Response) {
        view?.roomSaved(Model.LoadCreateNewStudeRoom.ViewModel(success: response.success, errorMessage: response.errorMessage))
    }
    
    
}
