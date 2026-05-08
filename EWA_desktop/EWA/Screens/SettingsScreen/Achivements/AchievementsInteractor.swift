final class AchievementsInteractor : AchievementsBusinessLogic{
    
    var presenter: AchievementsPresentationLogic
    
    init (presenter: AchievementsPresentationLogic) {
        self.presenter = presenter
    }
    
}
