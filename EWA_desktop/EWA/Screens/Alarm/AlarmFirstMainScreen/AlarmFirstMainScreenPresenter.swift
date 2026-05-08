final class  AlarmFirstMainScreenPresenter :  AlarmFirstMainScreenPresentationLogic  {
    
    typealias Model = AlarmFirstMainScreenModel
    
    weak var view: AlarmFirstMainScreenViewController?
    
    func presentAlarms(_ response: Model.LoadAlarmMainScreen.Response) {
        let mappedItems = response.alarms.map {
            AlarmCardView.Model(id: $0.id, description: $0.description, category: $0.category, categoryHexColor: $0.categoryHexColor, dateText: $0.date + " " + $0.time, avatarIconName: $0.user.iconName, buttonTitle: "Разбудить!", count: $0.countPart)
        }
        
        let viewModel = Model.LoadAlarmMainScreen.ViewModel(
            items: mappedItems,
            page: response.page,
            last: response.last,
            errorMessage: response.errorMessage,
            alarms: response.alarms
        )
        
        view?.displayAlarms(viewModel)
    }
    
    func presentRegisterUser(_ response: Model.RegisterUserToAlarm.Response) {
        view?.displayRegistrationAnswer(Model.RegisterUserToAlarm.ViewModel(success: response.success, message: response.message))
    }
    
}
