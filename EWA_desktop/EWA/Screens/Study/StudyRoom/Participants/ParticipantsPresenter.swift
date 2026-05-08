final class  ParticipantsPresenter :  ParticipantsPresentationLogic  {
    
    typealias Model = ParticipantsModel
    
    weak var view: ParticipantsViewController?
    
    func presentAddToBlackList(_ response: Model.LoadAddBlackList.Response) {
        view?.diaplayAddToBlackListSuccess(vm: Model.LoadAddBlackList.ViewModel(error: response.error))
    }
    
    
}
