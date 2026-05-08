final class  BlackListPresenter :  BlackListPresentationLogic  {
   
    typealias Model = BlackListModel
    
    weak var view: BlackListViewController?
    
    func presentDeleteFromBlacklackList(_ response: Model.DeleteFromBlackList.Response) {
        view?.displaAddTolackListSuccess(vm: Model.DeleteFromBlackList.ViewModel(error: response.error))
    }
    
}
