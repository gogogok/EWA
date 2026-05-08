import Foundation

final class BlackListInteractor : BlackListBusinessLogic{
    
    var presenter: BlackListPresentationLogic
    
    init (presenter: BlackListPresentationLogic) {
        self.presenter = presenter
    }
    
    func deleteFromBlackList(_ request: Model.DeleteFromBlackList.Request) {
        guard let currentUserId = UserDefaults.standard.string(forKey: UserDefaultsKeys.id) else {
            presenter.presentDeleteFromBlacklackList(Model.DeleteFromBlackList.Response(error: "Ошибка при распозновании пользователя"))
            return
        }
        
        Task {
            do {
                let success = try await UserApiClient.shared.deleteFromBlacklist(
                    userId: currentUserId,
                    blockedUserId: request.userId
                )
                
                if success {
                    presenter.presentDeleteFromBlacklackList(Model.DeleteFromBlackList.Response(error: nil))
                }
            } catch {
                presenter.presentDeleteFromBlacklackList(Model.DeleteFromBlackList.Response(error: error.localizedDescription))
            }
        }
    }
    
    
}
