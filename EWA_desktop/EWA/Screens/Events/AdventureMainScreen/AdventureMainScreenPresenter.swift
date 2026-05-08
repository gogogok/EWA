final class  AdventureMainScreenPresenter :  AdventureMainScreenPresentationLogic  {
    
    typealias Model = AdventureMainScreenModel
    
    weak var view: AdventureMainScreenViewController?
    
    func presentEvents(_ response: Model.LoadAdventureMainScreen.Response) {
        let mappedItems = response.events.map {
            AdventureCardView.Model(
                id: $0.id,
                title: $0.name,
                description: $0.description,
                category: $0.category,
                dateText: "\($0.date) \($0.time)",
                avatarIconName: $0.user.iconName,
                buttonTitle: "Вперёд!"
            )
        }
        
        let viewModel = AdventureMainScreenModel.LoadAdventureMainScreen.ViewModel(
            items: mappedItems,
            page: response.page,
            last: response.last,
            errorMessage: response.errorMessage,
            events: response.events
        )
        
        view?.displayEvents(viewModel)
    }
    
    func presentRegisterUser(_ response: Model.RegisterUserToEvent.Response) {
        view?.displayRegistrationAnswer(Model.RegisterUserToEvent.ViewModel(success: response.success, message: response.message))
    }
    
}
