import Foundation

final class CreateNewRoomInteractor : CreateNewRoomBusinessLogic{
    
    var presenter: CreateNewRoomPresentationLogic
    let studyRoomClient = StudyApiClient.shared
    
    init (presenter: CreateNewRoomPresentationLogic) {
        self.presenter = presenter
    }
    
    func saveRoom(_ request: Model.LoadCreateNewStudeRoom.Request) {
        Task {
            do {
                let result = try await studyRoomClient.addRoomToDataBase(room: request.roomRequest)
                print(result)
                
                presenter.presentRoom(
                    Model.LoadCreateNewStudeRoom.Response(
                        success: true,
                        errorMessage: "Комната создана"
                    )
                )
                
            } catch {
                presenter.presentRoom(
                    Model.LoadCreateNewStudeRoom.Response(
                        success: false,
                        errorMessage: error.localizedDescription
                    )
                )
            }
        }
    }
    
    
}
