import UIKit
import FirebaseAuth

class AdventureMainScreenViewController: UIViewController {
    
    typealias Model =  AdventureMainScreenModel
    
    //MARK: - Constants
    private enum Constants {
        
        static let fatalError: String = "Ошибка создания"

        static let backgroundLeftRight: CGFloat = 50
        
        static let topImageTop: CGFloat = 0
        static let topImageLeft: CGFloat = -150
        static let topImageHeight: CGFloat = 110
        
        static let buttonFont: String = "YanoneKaffeesatz-ExtraLight_Regular"
        static let tinosBold : String = "Tinos-Bold"
        
        static let welcomeLabelText: String = "Хочешь на мероприятие?\nНайди с кем пойти! "
        static let welcomeLabelFontSize: CGFloat = 28
        static let welcomeLabelTop: CGFloat = 85
        static let welcomeLabelHeight: CGFloat = 75
        static let welcomeLabelLeftRight: CGFloat = 50
        static let welcomeLabelCornerRadius: CGFloat = 10
        
        static let goLabelText: String = "Присоединись! "
        static let goLabelFontSize: CGFloat = 20
        static let goLabelTop: CGFloat = 10
        static let goLabelHeight: CGFloat = 40
        static let goLabelLeftRight: CGFloat = 100
        static let goLabelCornerRadius: CGFloat = 10
        
        static let searchText: String = "Найти ивент"
        static let searchTop: CGFloat = 30
        static let searchHeight: CGFloat = 60
        static let searchLeftRight: CGFloat = 20
        
        static let createButtonText: String = "Создать мероприятие"
        static let createButtonTop : CGFloat = 90
        static let createButtonLeft: CGFloat = 20
        static let createButtonWidth: CGFloat = 180
        static let createButtonHeight: CGFloat = 50
        static let createButtonFontSize: CGFloat = 16
        static let createButtonCornerRadius: CGFloat = 10
        
        static let myEventsButtonText: String = "Мои ивенты"
        static let myEventsIcon: String = "speaking"
        static let myEventsButtonTop : CGFloat = 90
        static let myEventsButtonLeft: CGFloat = 40
        static let myEventsButtonWidth: CGFloat = 180
        static let myEventsButtonHeight: CGFloat = 50
        static let myEventsButtonFontSize: CGFloat = 16
        static let myEventseButtonCornerRadius: CGFloat = 10
        
        static let purple: String = "#9F5FFC"
        static let lightPurple: String = "#D0B9FF"
        static let lightLightPurple: String = "#E8D8FF"
        static let green: String = "#40A27B"
    }
    
    //MARK: - Fields
    
    var interactor :  AdventureMainScreenBusinessLogic
    
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
    var goLabel: PaddedLabel = PaddedLabel()
    let search: SearchInputView = SearchInputView(placeholder: Constants.searchText)
    let createButton: UIButton = UIButton(type: .system)
    let myEventsButton: GradientActionButton = GradientActionButton()
    
    private let tableView = UITableView()
    
    private var items: [AdventureCardView.Model] = []
    private var events: [EventResponse] = []
    
    private var allItems: [AdventureCardView.Model] = []
    private var allEvents: [EventResponse] = []
    
    private var currentPage = 0
    private let pageSize = 20
    private var isLoading = false
    private var hasMorePages = true
    
    //MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadFirstPage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //MARK: - Lyfecycle
    init(interactor:  AdventureMainScreenBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFirstPage()
    }
    
    //MARK: - Configure UI
    private func configureUI() {
        configureBackgroudUI()
        configureWelcomeLabel()
        configureGoLabel()
        configureSearchLabel()
        configureCreateButton()
        configureEventsButton()
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
    
    private func configureGoLabel() {
        view.addSubview(goLabel)
        goLabel.text = Constants.goLabelText
        goLabel.textAlignment = .center
        goLabel.textColor = .black
        goLabel.font = UIFont(name: Constants.buttonFont, size: Constants.goLabelFontSize)
        goLabel.numberOfLines = 2
        goLabel.pinTop(to: welcomeLabel.bottomAnchor, Constants.goLabelTop)
        goLabel.pinHorizontal(to: view, Constants.goLabelLeftRight)
        goLabel.setHeight(Constants.goLabelHeight)
        
        goLabel.layer.borderWidth = 1
        goLabel.layer.cornerRadius = Constants.goLabelCornerRadius
        goLabel.layer.masksToBounds = true
        goLabel.backgroundColor = ColorChangindMethods.getHEXColor(hex: Constants.lightPurple)
    }
    
    private func configureSearchLabel() {
        view.addSubview(search)
        search.pinTop(to: goLabel.bottomAnchor, Constants.searchTop)
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
    
    private func configureEventsButton() {
        view.addSubview(myEventsButton)
        
        let image = UIImage(named: Constants.myEventsIcon)
        myEventsButton.configure(title: Constants.myEventsButtonText, image: image)
        
        myEventsButton.pinLeft(to: createButton.trailingAnchor, Constants.myEventsButtonLeft)
        myEventsButton.pinVertical(to: createButton)
        myEventsButton.pinRight(to: view.safeAreaLayoutGuide.trailingAnchor, Constants.myEventsButtonLeft)
        
        myEventsButton.addTarget(self, action: #selector(goToMyEvents), for: .touchUpInside)
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
        
        tableView.register(AdventureCardCell.self, forCellReuseIdentifier: AdventureCardCell.reuseIdentifier)
    }
    
    private func loadFirstPage() {
        currentPage = 0
        hasMorePages = true
        items = []
        tableView.reloadData()
        interactor.loadEvents(Model.LoadAdventureMainScreen.Request(page: currentPage, limit: pageSize))
    }
    
    private func loadNextPageIfNeeded() {
        guard !isLoading, hasMorePages else { return }
        isLoading = true
        interactor.loadEvents(Model.LoadAdventureMainScreen.Request(page: currentPage, limit: pageSize))
    }
    
    func displayEvents(_ vm: AdventureMainScreenModel.LoadAdventureMainScreen.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.isLoading = false
            
            if let error = vm.errorMessage {
                self.showMessage(error, "Ошибка")
                return
            }
            
            if vm.page == 0 {
                self.allItems = vm.items
                self.allEvents = vm.events
            } else {
                self.allItems.append(contentsOf: vm.items)
                self.allEvents.append(contentsOf: vm.events)
            }

            self.items = self.allItems
            self.events = self.allEvents
            
            self.hasMorePages = !vm.last
            self.currentPage = vm.page + 1
            
            self.tableView.reloadData()
        }
    }
    
    func displayRegistrationAnswer(_ vm: Model.RegisterUserToEvent.ViewModel) {
        if (vm.success) {
            showMessage(vm.message, "Успех")
        } else {
            showMessage(vm.message, "Ошибка")
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
    
    private func filterEvents(by query: String) {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedQuery.isEmpty else {
            items = allItems
            events = allEvents
            tableView.reloadData()
            return
        }
        
        let filteredPairs = zip(allItems, allEvents).filter { item, event in
            event.name.localizedCaseInsensitiveContains(trimmedQuery)
        }
        
        items = filteredPairs.map { $0.0 }
        events = filteredPairs.map { $0.1 }
        
        tableView.reloadData()
    }
    
    
    //MARK: - Target func
    @objc
    private func createButtonTapped() {
        let vc = CreateNewEventAssembly.build()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func goToMyEvents() {
        let vc = MyEventsAssembly.build()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func searchTextChanged() {
        filterEvents(by: search.text)
    }
}

extension AdventureMainScreenViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: AdventureCardCell.reuseIdentifier,
            for: indexPath
        ) as? AdventureCardCell else {
            return UITableViewCell()
        }
        
        let item = items[indexPath.row]
        let event = events[indexPath.row]
        cell.configure(with: item)
        
        cell.onJoinTap = { [weak self] in
            self?.interactor.registarUser(Model.RegisterUserToEvent.Request(eventId: event.id, userId: UserDefaults.standard.string(forKey: UserDefaultsKeys.id)))
        }
        
        cell.onCardTap = { [weak self] in
            let vc = ShowMoreEventsAssembly.build(event: event)
            vc.modalPresentationStyle = .overCurrentContext
            self?.present(vc, animated: true, completion: nil)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let threshold = items.count - 5
        if indexPath.row == threshold {
            loadNextPageIfNeeded()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        130
    }
}
