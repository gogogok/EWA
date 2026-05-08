import Foundation

protocol AchievementsBusinessLogic {
    typealias Model = AchievementsModel
}

protocol AchievementsPresentationLogic: AnyObject {
    typealias Model = AchievementsModel

    var view:  AchievementsViewController? {get set}
}


