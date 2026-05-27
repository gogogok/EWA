import UIKit

final class StudyRoomViewController: UIViewController {
    
    typealias Model = StudyRoomModel
    
    private enum Constants {
        static let fatalError: String = "Ошибка создания"
        
        static let backgroundLeftRight: CGFloat = 50
        
        static let topImageTop: CGFloat = -18
        static let topImageLeft: CGFloat = 25
        static let topImageHeight: CGFloat = 170
        
        static let bottonImageHeight: CGFloat = 170
        static let bottonImageHBottom: CGFloat = -10
        
        static let backButtonWidthConstant: CGFloat = 2.3
        static let backButtonTop: CGFloat = -120
        
        static let peopleButtonText: String = "Участники"
        static let peopleIcon: String = "user"
        static let peopleButtonTop : CGFloat = 90
        static let peopleButtonLeft: CGFloat = 30
        static let peopleButtonWidth: CGFloat = 180
        static let peopleButtonHeight: CGFloat = 50
        static let peopleButtonFontSize: CGFloat = 16
        static let peopleButtonCornerRadius: CGFloat = 10
        
        static let yanoneKaffeesatz: String = "YanoneKaffeesatz-ExtraLight_Regular"
    }
    
    var interactor: StudyRoomBusinessLogic
    
    private var didLeaveRoom = false
    
    private let room: StudyResponse
    private let videoView = YouTubeVideoView()
    
    private var webSocketManager: VideoSyncWebSocketManager?
    
    private let seekBackButton = UIButton(type: .system)
    private let seekForwardButton = UIButton(type: .system)
    
    private var chatSocketManager: ChatWebSocketManager?

    private var messages: [ChatMessage] = []
    
    private var studyStartedAt: Date?

    private let chatContainerView = UIView()
    private let chatTitleLabel = UILabel()
    private let messagesTableView = UITableView()
    private let messageTextField = UITextField()
    private let sendButton = UIButton(type: .system)
    
    let peopleButton: GradientActionButton = GradientActionButton()
    
    let background: UIImageView = {
        let label = UIImageView()
        label.image = UIImage(named: "птица_фон")
        label.contentMode = .scaleAspectFit
        label.tintColor = .white
        return label
    }()
    
    let top_image: UIImageView = {
        let label = UIImageView()
        label.image = UIImage(named: "right_top_registation")
        label.contentMode = .scaleAspectFit
        label.tintColor = .white
        return label
    }()
    
    let customBackButton = UIButton(type: .system)
    
    
    init(interactor: StudyRoomBusinessLogic, room: StudyResponse) {
        self.interactor = interactor
        self.room = room
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    deinit {
        webSocketManager?.disconnect()
        chatSocketManager?.disconnect()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        studyStartedAt = Date()
        configureUI()
    }
    
    private func configureUI() {
        configureBackgroudUI()
        configurebackButton()
        configurePeopleButton()
        configurevideoView()
        configureVideo()
        configureWebSocket()
        configureChatUI()
        configureChatWebSocket()
        configureKeyboardDismiss()
    }
    
    private func configureBackgroudUI() {
        view.addSubview(background)
        view.addSubview(top_image)
        
        view.backgroundColor = .white
        
        top_image.pinTop(to: view, Constants.topImageTop)
        top_image.pinLeft(to: view.leadingAnchor, Constants.topImageLeft)
        top_image.setHeight(Constants.topImageHeight)
        
        background.pinCenter(to: view)
        background.pinHorizontal(to: view, Constants.backgroundLeftRight)
        
        view.sendSubviewToBack(top_image)
        view.sendSubviewToBack(background)
    }
    
    private func configurebackButton() {
        let img = UIImage(named: "back_button")?.withRenderingMode(.alwaysOriginal)
        customBackButton.setImage(img, for: .normal)
        customBackButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        customBackButton.imageView?.contentMode = .scaleAspectFit
        
        view.addSubview(customBackButton)
        let viewWidth: CGFloat = view.frame.width
        customBackButton.pinTop(to: view.topAnchor, Constants.backButtonTop)
        customBackButton.setWidth(viewWidth / Constants.backButtonWidthConstant)
        customBackButton.pinLeft(to: view)
    }
    
    private func configurePeopleButton() {
        view.addSubview(peopleButton)
        
        let image = UIImage(named: Constants.peopleIcon)
        peopleButton.configure(title: Constants.peopleButtonText, image: image)
        peopleButton.setHeight(50)
        peopleButton.pinCenterY(to: customBackButton)
        peopleButton.pinRight(to: view.safeAreaLayoutGuide.trailingAnchor, Constants.peopleButtonLeft)
        
        
       peopleButton.addTarget(self, action: #selector(goToParticipants), for: .touchUpInside)
    }
    
    private func configurevideoView() {
        view.addSubview(videoView)
        videoView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 120)
        videoView.pinHorizontal(to: view, 30)
        videoView.setHeight(220)
        
        view.addSubview(seekBackButton)
        view.addSubview(seekForwardButton)
        
        seekBackButton.translatesAutoresizingMaskIntoConstraints = false
        seekForwardButton.translatesAutoresizingMaskIntoConstraints = false
        
        seekBackButton.setTitle("-10 сек", for: .normal)
        seekForwardButton.setTitle("+10 сек", for: .normal)
        
        seekBackButton.setTitleColor(.black, for: .normal)
        seekForwardButton.setTitleColor(.black, for: .normal)
        
        seekBackButton.backgroundColor = .white
        seekForwardButton.backgroundColor = .white
        
        seekBackButton.layer.cornerRadius = 10
        seekForwardButton.layer.cornerRadius = 10
        
        seekBackButton.addTarget(self, action: #selector(seekBackTapped), for: .touchUpInside)
        seekForwardButton.addTarget(self, action: #selector(seekForwardTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            
            seekBackButton.topAnchor.constraint(equalTo: videoView.bottomAnchor, constant: 14),
            seekBackButton.leadingAnchor.constraint(equalTo: videoView.leadingAnchor),
            seekBackButton.widthAnchor.constraint(equalToConstant: 100),
            seekBackButton.heightAnchor.constraint(equalToConstant: 40),
            
            seekForwardButton.topAnchor.constraint(equalTo: videoView.bottomAnchor, constant: 14),
            seekForwardButton.trailingAnchor.constraint(equalTo: videoView.trailingAnchor),
            seekForwardButton.widthAnchor.constraint(equalToConstant: 100),
            seekForwardButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureChatUI() {
        view.addSubview(chatContainerView)
        chatContainerView.translatesAutoresizingMaskIntoConstraints = false
        chatContainerView.backgroundColor = UIColor(red: 0.88, green: 0.84, blue: 0.84, alpha: 1)
        chatContainerView.layer.cornerRadius = 14
        chatContainerView.layer.borderWidth = 1
        chatContainerView.layer.borderColor = UIColor.black.cgColor
        chatContainerView.clipsToBounds = true

        chatContainerView.addSubview(chatTitleLabel)
        chatContainerView.addSubview(messagesTableView)
        chatContainerView.addSubview(messageTextField)
        chatContainerView.addSubview(sendButton)

        chatTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        messagesTableView.translatesAutoresizingMaskIntoConstraints = false
        messageTextField.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false

        chatTitleLabel.text = "Чат"
        chatTitleLabel.font = UIFont(name: Constants.yanoneKaffeesatz, size: 30)
        chatTitleLabel.textAlignment = .center
        chatTitleLabel.textColor = .black

        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        messagesTableView.register(ChatMessageCell.self, forCellReuseIdentifier: ChatMessageCell.reuseId)
        messagesTableView.rowHeight = UITableView.automaticDimension
        messagesTableView.estimatedRowHeight = 70
        messagesTableView.backgroundColor = .clear
        messagesTableView.separatorStyle = .none

        messageTextField.placeholder = "Сообщение"
        messageTextField.backgroundColor = .white
        messageTextField.layer.cornerRadius = 18
        messageTextField.layer.borderWidth = 1
        messageTextField.layer.borderColor = UIColor.black.cgColor
        messageTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 1))
        messageTextField.leftViewMode = .always
        messageTextField.returnKeyType = .send
        messageTextField.delegate = self

        sendButton.setImage(UIImage(systemName: "paperplane"), for: .normal)
        sendButton.tintColor = .black
        sendButton.layer.cornerRadius = 22
        sendButton.layer.borderWidth = 1
        sendButton.layer.borderColor = UIColor.black.cgColor
        sendButton.addTarget(self, action: #selector(sendMessageTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            chatContainerView.topAnchor.constraint(equalTo: seekBackButton.bottomAnchor, constant: 20),
            chatContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            chatContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            chatContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),

            chatTitleLabel.topAnchor.constraint(equalTo: chatContainerView.topAnchor, constant: 12),
            chatTitleLabel.leadingAnchor.constraint(equalTo: chatContainerView.leadingAnchor),
            chatTitleLabel.trailingAnchor.constraint(equalTo: chatContainerView.trailingAnchor),
            chatTitleLabel.heightAnchor.constraint(equalToConstant: 36),

            messagesTableView.topAnchor.constraint(equalTo: chatTitleLabel.bottomAnchor, constant: 8),
            messagesTableView.leadingAnchor.constraint(equalTo: chatContainerView.leadingAnchor, constant: 12),
            messagesTableView.trailingAnchor.constraint(equalTo: chatContainerView.trailingAnchor, constant: -12),
            messagesTableView.bottomAnchor.constraint(equalTo: messageTextField.topAnchor, constant: -12),

            messageTextField.leadingAnchor.constraint(equalTo: chatContainerView.leadingAnchor, constant: 30),
            messageTextField.bottomAnchor.constraint(equalTo: chatContainerView.bottomAnchor, constant: -16),
            messageTextField.heightAnchor.constraint(equalToConstant: 44),

            sendButton.leadingAnchor.constraint(equalTo: messageTextField.trailingAnchor, constant: 10),
            sendButton.trailingAnchor.constraint(equalTo: chatContainerView.trailingAnchor, constant: -16),
            sendButton.centerYAnchor.constraint(equalTo: messageTextField.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 44),
            sendButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func configureChatWebSocket() {
        guard let userId = UserDefaults.standard.string(forKey: UserDefaultsKeys.id) else {
            return
        }

        let username = UserDefaults.standard.string(forKey: UserDefaultsKeys.username) ?? "User"

        let manager = ChatWebSocketManager(
            roomId: room.id,
            userId: userId,
            username: username
        )

        manager.onMessageReceived = { [weak self] message in
            guard let self else { return }

            self.messages.append(message)
            self.messagesTableView.reloadData()

            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }

        manager.connect()
        chatSocketManager = manager
    }

    @objc
    private func sendMessageTapped() {
        guard let text = messageTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty else {
            messageTextField.resignFirstResponder()
            return
        }

        chatSocketManager?.send(text: text)
        
        AchievementsCounter().incrementMessagesSent()
        
        messageTextField.text = ""
        messageTextField.resignFirstResponder()
    }
    
    @objc
    private func goToParticipants() {
        let vc = ParticipantsAssembly.build(room: room)
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    
    private func configureVideo() {
        videoView.delegate = self
        
        guard let videoId = extractYouTubeVideoId(from: room.mediaUrl) else {
            showMessage("Не удалось открыть видео", "Ошибка")
            return
        }
        
        videoView.loadVideo(videoId: videoId)
    }
    
    private func configureWebSocket() {
        guard let userId = UserDefaults.standard.string(forKey: UserDefaultsKeys.id) else {
            return
        }
        
        let manager = VideoSyncWebSocketManager(
            roomId: room.id,
            userId: userId
        )
        
        manager.onEventReceived = { [weak self] event in
            self?.handleRemoteVideoEvent(event)
        }
        
        manager.connect()
        webSocketManager = manager
    }
    
    private func handleRemoteVideoEvent(_ event: VideoSyncEvent) {
        guard let myUserId = UserDefaults.standard.string(forKey: UserDefaultsKeys.id) else {
            return
        }
        
        guard event.userId != myUserId else {
            return
        }
        
        switch event.action {
        case .play:
            let correctedTime = correctedTime(for: event)
            videoView.seekFromRemote(to: correctedTime)
            videoView.playFromRemote()
            
        case .pause:
            videoView.seekFromRemote(to: event.currentTime)
            videoView.pauseFromRemote()
            
        case .seek:
            videoView.seekFromRemote(to: event.currentTime)
        }
    }
    
    private func correctedTime(for event: VideoSyncEvent) -> Double {
        let now = Date().timeIntervalSince1970
        let delay = now - event.sentAt
        return event.currentTime + max(delay, 0)
    }
    
    private func configureKeyboardDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc
    private func seekBackTapped() {
        videoView.getCurrentTime { [weak self] currentTime in
            guard let self else { return }
            
            let newTime = max(currentTime - 10, 0)
            self.videoView.seekFromRemote(to: newTime)
            self.webSocketManager?.send(action: .seek, currentTime: newTime)
        }
    }
    
    @objc
    private func seekForwardTapped() {
        videoView.getCurrentTime { [weak self] currentTime in
            guard let self else { return }
            
            let newTime = currentTime + 10
            self.videoView.seekFromRemote(to: newTime)
            self.webSocketManager?.send(action: .seek, currentTime: newTime)
        }
    }
    
    private func showMessage(_ message: String, _ title: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }

    
    //MARK: - Target func
    @objc
    func goBack() {
        leaveRoomAndClose()
    }
    
    //MARK: - Help func
    private func extractYouTubeVideoId(from url: String) -> String? {
        if let components = URLComponents(string: url),
           let videoId = components.queryItems?.first(where: { $0.name == "v" })?.value {
            return videoId
        }

        if url.contains("youtu.be/") {
            return url
                .components(separatedBy: "youtu.be/")
                .last?
                .components(separatedBy: "?")
                .first
        }

        if url.contains("youtube.com/embed/") {
            return url
                .components(separatedBy: "youtube.com/embed/")
                .last?
                .components(separatedBy: "?")
                .first
        }

        return nil
    }

    private func leaveRoomAndClose() {
        guard !didLeaveRoom else { return }
        didLeaveRoom = true
        
        trackStudyTimeIfNeeded()

        webSocketManager?.disconnect()
        chatSocketManager?.disconnect()

        guard let userId = UserDefaults.standard.string(forKey: UserDefaultsKeys.id) else {
            dismiss(animated: true)
            return
        }

        StudyParticipantsApiClient.shared.leaveRoom(
            roomId: room.id,
            userId: userId
        ) { [weak self] success in
            DispatchQueue.main.async {
                print("LEFT ROOM:", success)
                self?.dismiss(animated: true)
            }
        }
    }
    
    private func trackStudyTimeIfNeeded() {
        guard let studyStartedAt else { return }

        let seconds = Date().timeIntervalSince(studyStartedAt)
        let minutes = Int(seconds / 60)

        AchievementsCounter().updateStudyStreak(minutes: minutes)
    }
}


extension StudyRoomViewController: YouTubeVideoViewDelegate {
    
    func youtubeVideoViewDidPlay(_ view: YouTubeVideoView, currentTime: Double) {
        webSocketManager?.send(action: .play, currentTime: currentTime)
    }
    
    func youtubeVideoViewDidPause(_ view: YouTubeVideoView, currentTime: Double) {
        webSocketManager?.send(action: .pause, currentTime: currentTime)
    }
}

extension StudyRoomViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatMessageCell.reuseId,
            for: indexPath
        ) as? ChatMessageCell else {
            return UITableViewCell()
        }

        let message = messages[indexPath.row]
        let myUserId = UserDefaults.standard.string(forKey: UserDefaultsKeys.id)
        let isMine = message.userId == myUserId

        cell.configure(with: message, isMine: isMine)

        return cell
    }
}
   
extension StudyRoomViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessageTapped()
        return true
    }
}

    
   
