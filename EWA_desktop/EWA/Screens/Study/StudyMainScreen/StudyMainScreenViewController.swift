import UIKit
import SwiftUI
import FirebaseAuth

struct StudyMainScreenPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            StudyMainScreenViewController(interactor: MockStudyMainScreenInteractor())
        }
    }
}

class StudyMainScreenViewController: UIViewController {
    
    typealias Model =  StudyMainScreenModel
    
    //MARK: - Constants
    private enum Constants {
        
        static let fatalError: String = "Ошибка создания"
        
        static let backgroundLeftRight: CGFloat = 50
        
        static let topImageTop: CGFloat = 0
        static let topImageLeft: CGFloat = -150
        static let topImageHeight: CGFloat = 110
        
        static let buttonFont: String = "YanoneKaffeesatz-ExtraLight_Regular"
        static let tinosBold : String = "Tinos-Bold"
        
        static let welcomeLabelText: String = "Нет мотивации учиться? Помощь рядом! "
        static let welcomeLabelFontSize: CGFloat = 28
        static let welcomeLabelTop: CGFloat = 85
        static let welcomeLabelHeight: CGFloat = 75
        static let welcomeLabelLeftRight: CGFloat = 50
        static let welcomeLabelCornerRadius: CGFloat = 10
        
        static let searchText: String = "Найти комнату"
        static let searchTop: CGFloat = 20
        static let searchHeight: CGFloat = 60
        static let searchLeftRight: CGFloat = 20
        
        static let createButtonText: String = "Создать комнату"
        static let createButtonTop : CGFloat = 90
        static let createButtonLeft: CGFloat = 20
        static let createButtonWidth: CGFloat = 170
        static let createButtonHeight: CGFloat = 35
        static let createButtonFontSize: CGFloat = 16
        static let createButtonCornerRadius: CGFloat = 10
        
        static let myEventsButtonText: String = "В случайную комнату"
        static let myEventsIcon: String = "speaking"
        static let myEventsButtonTop : CGFloat = 90
        static let myEventsButtonLeft: CGFloat = 40
        static let myEventsButtonWidth: CGFloat = 170
        static let myEventsButtonHeight: CGFloat = 35
        static let myEventsButtonFontSize: CGFloat = 16
        static let myEventseButtonCornerRadius: CGFloat = 10
        
        static let purple: String = "#9F5FFC"
        static let lightPurple: String = "#D0B9FF"
        static let lightLightPurple: String = "#E8D8FF"
        static let green: String = "#40A27B"
        static let lightGreen: String = "#9DE8CE"
    }
    
    //MARK: - Fields
    
    var interactor :  StudyMainScreenBusinessLogic
    
    let background: UIImageView = {
        let label = UIImageView()
        label.image = UIImage(named: "птица_фон")
        label.contentMode = .scaleAspectFit
        label.tintColor = .white
        return label
    }()
    
    let top_image: UIImageView = {
        let label = UIImageView()
        label.image = UIImage(named: "right_top_adv")
        label.contentMode = .scaleAspectFit
        label.tintColor = .white
        return label
    }()
    
    var welcomeLabel: PaddedLabel = PaddedLabel()
    let search: SearchInputView = SearchInputView(placeholder: Constants.searchText)
    let createButton: UIButton = UIButton(type: .system)
    let randomRoomButton: UIButton = UIButton(type: .system)
    
    private let tableView = UITableView()
    
    private var items: [StudyCardView.Model] = []
    private var rooms: [StudyResponse] = []
    
    private var allItems: [StudyCardView.Model] = []
    private var allRoomes: [StudyResponse] = []
    
    private var currentPage = 0
    private let pageSize = 20
    private var isLoading = false
    private var hasMorePages = true
    
    //MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //MARK: - Lyfecycle
    init(interactor:  StudyMainScreenBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard !isLoading else { return }
        loadFirstPage()
    }
    
    //MARK: - Configure UI
    private func configureUI() {
        configureBackgroudUI()
        configureWelcomeLabel()
        configureSearchLabel()
        configureCreateButton()
        configureRandomButton()
        configureTableView()
    }
    
    private func configureBackgroudUI() {
        view.backgroundColor = .white
        view.addSubview(background)
        view.addSubview(top_image)
        
        view.backgroundColor = .white
        top_image.pinTop(to: view, Constants.topImageTop)
        top_image.pinRight(to: view.trailingAnchor, Constants.topImageLeft)
        top_image.setHeight(Constants.topImageHeight)
        
        
        background.pinCenter(to: view)
        background.pinHorizontal(to: view, Constants.backgroundLeftRight)
        
        view.sendSubviewToBack(top_image)
        view.sendSubviewToBack(background)
    }
    
    private func configureWelcomeLabel() {
        view.addSubview(welcomeLabel)
        welcomeLabel.text = Constants.welcomeLabelText
        welcomeLabel.textAlignment = .center
        welcomeLabel.textColor = .black
        welcomeLabel.font = UIFont(name: Constants.buttonFont, size: Constants.welcomeLabelFontSize)
        welcomeLabel.numberOfLines = 2
        welcomeLabel.pinTop(to: view, Constants.welcomeLabelTop)
        welcomeLabel.pinHorizontal(to: view, Constants.welcomeLabelLeftRight)
        welcomeLabel.setHeight(Constants.welcomeLabelHeight)
        
        welcomeLabel.layer.borderWidth = 1
        welcomeLabel.layer.cornerRadius = Constants.welcomeLabelCornerRadius
        welcomeLabel.layer.masksToBounds = true
        welcomeLabel.backgroundColor = ColorChangindMethods.getHEXColor(hex: Constants.lightPurple)
    }
    
    
    private func configureSearchLabel() {
        view.addSubview(search)
        search.pinTop(to: welcomeLabel.bottomAnchor, Constants.searchTop)
        search.pinHorizontal(to: view, Constants.searchLeftRight)
        search.setHeight(Constants.searchHeight)
        search.textField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
    }
    
    private func configureCreateButton() {
        view.addSubview(createButton)
        createButton.setTitle(Constants.createButtonText, for: .normal)
        createButton.titleLabel?.numberOfLines = 2
        createButton.titleLabel?.textAlignment = .center
        createButton.setTitleColor(.black, for: .normal)
        createButton.titleLabel?.font = UIFont(name: Constants.tinosBold, size: Constants.createButtonFontSize)
        createButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, Constants.createButtonTop)
        createButton.pinLeft(to: view.leadingAnchor, Constants.createButtonLeft)
        createButton.setWidth(Constants.createButtonWidth)
        createButton.setHeight(Constants.createButtonHeight)
        
        createButton.layer.borderWidth = 1
        createButton.layer.cornerRadius = Constants.createButtonCornerRadius
        createButton.layer.masksToBounds = true
        createButton.backgroundColor = ColorChangindMethods.getHEXColor(hex: Constants.purple)
        
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
    }
    
    private func configureRandomButton() {
        view.addSubview(randomRoomButton)
        
        randomRoomButton.setTitle(Constants.myEventsButtonText, for: .normal)
        randomRoomButton.titleLabel?.numberOfLines = 2
        randomRoomButton.titleLabel?.textAlignment = .center
        randomRoomButton.setTitleColor(.black, for: .normal)
        randomRoomButton.titleLabel?.font = UIFont(name: Constants.tinosBold, size: Constants.createButtonFontSize)
        randomRoomButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, Constants.createButtonTop)
        randomRoomButton.pinRight(to: view.trailingAnchor, Constants.createButtonLeft)
        randomRoomButton.setWidth(Constants.createButtonWidth)
        randomRoomButton.setHeight(Constants.createButtonHeight)
        
        randomRoomButton.layer.borderWidth = 1
        randomRoomButton.layer.cornerRadius = Constants.createButtonCornerRadius
        randomRoomButton.layer.masksToBounds = true
        randomRoomButton.backgroundColor = ColorChangindMethods.getHEXColor(hex: Constants.lightGreen)
        
        randomRoomButton.addTarget(self, action: #selector(goToRandomRoom), for: .touchUpInside)
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.pinTop(to: search.bottomAnchor, 10)
        tableView.pinLeft(to: view.leadingAnchor, 0)
        tableView.pinRight(to: view.trailingAnchor, 0)
        tableView.pinBottom(to: createButton.topAnchor, 5)
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 24, right: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(StudyCardCell.self, forCellReuseIdentifier: StudyCardCell.reuseIdentifier)
    }
    
    private func loadFirstPage() {
        guard !isLoading else { return }

        currentPage = 0
        hasMorePages = true
        isLoading = true

        items = []
        rooms = []
        allItems = []
        allRoomes = []

        tableView.reloadData()

        interactor.loadRooms(
            Model.LoadStudyMainScreen.Request(
                page: currentPage,
                limit: pageSize
            )
        )
    }
    
    private func loadNextPageIfNeeded() {
        guard !isLoading, hasMorePages else { return }

        isLoading = true

        interactor.loadRooms(
            Model.LoadStudyMainScreen.Request(
                page: currentPage,
                limit: pageSize
            )
        )
    }
    
    func displayRooms(_ vm: Model.LoadStudyMainScreen.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            if let error = vm.errorMessage {
                self.isLoading = false
                self.showMessage(error, "Ошибка")
                return
            }

            if vm.page == 0 {
                self.allItems = vm.items
                self.allRoomes = vm.rooms
            } else {
                self.allItems.append(contentsOf: vm.items)
                self.allRoomes.append(contentsOf: vm.rooms)
            }

            self.items = self.allItems
            self.rooms = self.allRoomes

            self.hasMorePages = !vm.last
            self.currentPage = vm.page + 1

            self.tableView.reloadData()

            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
    
    private func showMessage(_ message: String, _ title: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Ок", style: .default) { _ in
            completion?()
        })
        
        present(alert, animated: true)
    }
    
    private func filterRooms(by query: String) {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedQuery.isEmpty else {
            items = allItems
            rooms = allRoomes
            tableView.reloadData()
            return
        }
        
        let filteredPairs = zip(allItems, allRoomes).filter { item, event in
            event.name.localizedCaseInsensitiveContains(trimmedQuery)
        }
        
        items = filteredPairs.map { $0.0 }
        rooms = filteredPairs.map { $0.1 }
        
        tableView.reloadData()
    }
    
    
    //MARK: - Target func
    @objc
    private func createButtonTapped() {
        let vc = CreateNewRoomAssembly.build()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func goToRandomRoom() {
        randomRoomButton.isEnabled = false

        StudyApiClient.shared.getRandomPublicRoom { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }

                self.randomRoomButton.isEnabled = true

                switch result {
                case .success(let room):
                    self.interactor.registerParticipant(
                        Model.LoadERegistration.Request(room: room)
                    )

                    let vc = StudyRoomAssembly.build(room: room)
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)

                case .failure:
                    self.showMessage("Сейчас нет доступных публичных комнат", "Ошибка")
                }
            }
        }
    }
    
    @objc
    private func searchTextChanged() {
        filterRooms(by: search.text)
    }
}

extension StudyMainScreenViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: StudyCardCell.reuseIdentifier,
            for: indexPath
        ) as? StudyCardCell else {
            return UITableViewCell()
        }
        
        guard indexPath.row < items.count,
              indexPath.row < rooms.count else {
            return cell
        }
        
        let item = items[indexPath.row]
        cell.configure(with: item)
        
        cell.onJoinTap = { [weak self, weak tableView, weak cell] in
            guard let self else {
                return
            }
            
            guard let tableView else {
                return
            }
            
            guard let cell else {
            
                return
            }
            
            guard let currentIndexPath = tableView.indexPath(for: cell) else {
                return
            }
            
            guard currentIndexPath.row < self.items.count,
                  currentIndexPath.row < self.rooms.count else {
                return
            }
            
            let currentRoom = self.rooms[currentIndexPath.row]
            if currentRoom.type.lowercased().contains("private") {
                guard let pass = currentRoom.password else { return }
                
                self.interactor.registerParticipant(Model.LoadERegistration.Request(room: currentRoom))
                let vc = EnterPasswordScreenAssembly.build(password: pass, room: currentRoom)
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: true)
            } else {
                self.interactor.registerParticipant(Model.LoadERegistration.Request(room: currentRoom))
                let vc = StudyRoomAssembly.build(room: currentRoom)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !isLoading, hasMorePages else { return }
        guard items.count >= 5 else { return }

        let threshold = items.count - 5

        if indexPath.row >= threshold {
            loadNextPageIfNeeded()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        105
    }
}
