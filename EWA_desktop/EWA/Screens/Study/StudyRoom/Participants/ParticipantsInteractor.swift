import Foundation

final class ParticipantsInteractor : ParticipantsBusinessLogic{
    
    var presenter: ParticipantsPresentationLogic
    
    init (presenter: ParticipantsPresentationLogic) {
        self.presenter = presenter
    }
    
    func addToBlackList(_ request: Model.LoadAddBlackList.Request) {
        guard let currentUserId = UserDefaults.standard.string(forKey: UserDefaultsKeys.id) else {
            presenter.presentAddToBlackList(Model.LoadAddBlackList.Response(error: "Ошибка при распозновании пользователя"))
            return
        }
        
        Task {
            do {
                let success = try await UserApiClient.shared.addToBlacklist(
                    userId: currentUserId,
                    blockedUserId: request.userId
                )
                
                if success {
                    presenter.presentAddToBlackList(Model.LoadAddBlackList.Response(error: nil))
                }
            } catch {
                presenter.presentAddToBlackList(Model.LoadAddBlackList.Response(error: error.localizedDescription))
            }
        }
        
    }
    
}
