final class  StudyMainScreenPresenter :  StudyMainScreenPresentationLogic  {
    
    typealias Model = StudyMainScreenModel
    
    weak var view: StudyMainScreenViewController?
    
    func presentRooms(_ response: Model.LoadStudyMainScreen.Response) {
        let mappedItems = response.rooms.map {
            StudyCardView.Model(id: $0.id, name: $0.name, description: $0.description, category: $0.category, type: $0.type, avatarIconName: $0.user.iconName, mediaURl: $0.mediaUrl)
        }
        
        let viewModel = Model.LoadStudyMainScreen.ViewModel(
            items: mappedItems,
            page: response.page,
            last: response.last,
            errorMessage: response.errorMessage,
            rooms: response.rooms)
        
        view?.displayRooms(viewModel)
    }
    
    func presentPasswordPanel(_ response: Model.LoadEnterPassword.Response) {
//        print("presenter")
//        view?.displayJoin(Model.LoadEnterPassword.ViewModel(room: response.room, type: response.type, password: response.password))
    }
}
