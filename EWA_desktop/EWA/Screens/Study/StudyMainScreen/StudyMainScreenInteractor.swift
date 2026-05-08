import Foundation

final class StudyMainScreenInteractor : StudyMainScreenBusinessLogic{

    var presenter: StudyMainScreenPresentationLogic
    var studyClient = StudyApiClient.shared
    
    init (presenter: StudyMainScreenPresentationLogic) {
        self.presenter = presenter
    }
    
    func loadRooms(_ request: Model.LoadStudyMainScreen.Request) {
        Task {
            do {
                let response = try await studyClient.fetchRooms(page: request.page, size: request.limit)
                presenter.presentRooms(
                    Model.LoadStudyMainScreen.Response(
                        rooms: response.content,
                        page: response.page,
                        last: response.last,
                        errorMessage: nil
                    )
                )
            } catch {
                presenter.presentRooms(
                    Model.LoadStudyMainScreen.Response(
                        rooms: [],
                        page: request.page,
                        last: true,
                        errorMessage: error.localizedDescription
                    )
                )
            }
        }
    }
    
    func openPasswordPanel(_ request: Model.LoadEnterPassword.Request) {
        print("interactor")
        presenter.presentPasswordPanel(Model.LoadEnterPassword.Response(room: request.room, type: request.type, password: request.password))
    }
    
    func registerParticipant(_ request: Model.LoadERegistration.Request) {
        guard let userId = UserDefaults.standard.string(
            forKey: UserDefaultsKeys.id
        ) else {
            return
        }

        let username = UserDefaults.standard.string(
            forKey: UserDefaultsKeys.username
        ) ?? "User"

        let iconName = UserDefaults.standard.string(
            forKey: UserDefaultsKeys.iconName
        )

        let participant = StudyRoomParticipant(
            id: nil,
            roomId: request.room.id,
            userId: userId,
            username: username,
            iconName: iconName
        )

        StudyParticipantsApiClient.shared.joinRoom(
            roomId: request.room.id,
            participant: participant
        ) { success in

            print("JOINED ROOM:", success)
        }
    }
}
