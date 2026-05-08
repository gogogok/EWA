import UIKit
import FirebaseAuth
import SwiftUI

private enum AlarmScreenType {
    case almostWakeUp
    case wakeInAdvance
}

struct AlarmFirstMainScreenPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            AlarmFirstMainScreenViewController(interactor: MockAlarmFirstInteractor())
        }
    }
}

class AlarmFirstMainScreenViewController: UIViewController {
    
    typealias Model =  AlarmFirstMainScreenModel
    
    //MARK: - Constants
    private enum Constants {
        
        static let fatalError: String = "Ошибка создания"
        
        static let backgroundLeftRight: CGFloat = 50
        
        static let topImageTop: CGFloat = 0
        static let topImageLeft: CGFloat = -150
        static let topImageHeight: CGFloat = 110
        
        static let buttonFont: String = "YanoneKaffeesatz-ExtraLight_Regular"
        static let tinosBold : String = "Tinos-Bold"
        
        static let welcomeLabelText: String = "Важно не проспать? Помощь рядом! "
        static let welcomeLabelFontSize: CGFloat = 28
        static let welcomeLabelTop: CGFloat = 85
        static let welcomeLabelHeight: CGFloat = 75
        static let welcomeLabelLeftRight: CGFloat = 50
        static let welcomeLabelCornerRadius: CGFloat = 10
        
        static let createButtonText: String = "Установить время пробуждения"
        static let createButtonTop : CGFloat = 90
        static let createButtonLeft: CGFloat = 20
        static let createButtonWidth: CGFloat = 180
        static let createButtonHeight: CGFloat = 50
        static let createButtonFontSize: CGFloat = 16
        static let createButtonCornerRadius: CGFloat = 10
        
        static let alarmButtonText: String = "Мои часы"
        static let alarmIcon: String = "alarm_icon"
        static let alarmButtonTop : CGFloat = 90
        static let alarmButtonLeft: CGFloat = 40
        static let alarmButtonWidth: CGFloat = 180
        static let alarmButtonHeight: CGFloat = 50
        static let alarmButtonFontSize: CGFloat = 16
        static let alarmButtonCornerRadius: CGFloat = 10
        
        static let firstButtonText: String = "Вот-вот проснётся!"
        static let secondButtonText: String = "Разбудить заранее"
        static let buttonCornerRadius: CGFloat = 10
        
        static let purple: String = "#9F5FFC"
        static let lightPurple: String = "#D0B9FF"
        static let lightLightPurple: String = "#E8D8FF"
        static let green: String = "#40A27B"
        static let lightGreen: String = "#9DE8CE"
        static let darkGreen: String = "#8DC7B3"
        
        static let upButtonFontSize: CGFloat = 16
    }
    
    //MARK: - Fields
    
    var interactor : AlarmFirstMainScreenBusinessLogic
    
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
    let createButton: UIButton = UIButton(type: .system)
    let myAlarmsButton: GradientActionButton = GradientActionButton()
    var stackUpButtons: UIStackView = UIStackView()
    
    let firstPageButton: UIButton = UIButton(type: .system)
    let secondPageButton: UIButton = UIButton(type: .system)
    
    private let tableView = UITableView()
    
    private var items: [AlarmCardView.Model] = []
    private var alarms: [AlarmResponse] = []
    
    private var allItems: [AlarmCardView.Model] = []
    private var allAlarms: [AlarmResponse] = []
    
    private var currentScreenType: AlarmScreenType = .almostWakeUp
    
    private var currentPage = 0
    private let pageSize = 20
    private var isLoading = false
    private var hasMorePages = true
    
    //MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadFirstPage()
        let health = HealthClient()
        Task {
            do {
                try await print(health.fetchHealth().status)
            }
        }
        for family in UIFont.familyNames {
            print("Family: \(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("  - \(name)")
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //MARK: - Lyfecycle
    init(interactor:  AlarmFirstMainScreenBusinessLogic) {
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
        configureUpStack()
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
    
    private func configureUpStack() {
        view.addSubview(stackUpButtons)
        stackUpButtons.spacing = 20
        stackUpButtons.axis = .horizontal
        stackUpButtons.addArrangedSubview(firstPageButton)
        stackUpButtons.addArrangedSubview(secondPageButton)
        stackUpButtons.distribution = .fillEqually
        
        firstPageButton.setTitle(Constants.firstButtonText, for: .normal)
        firstPageButton.setHeight(45)
        firstPageButton.layer.borderWidth = 1
        firstPageButton.layer.cornerRadius = Constants.buttonCornerRadius
        firstPageButton.titleLabel?.font = UIFont(name: Constants.tinosBold, size: Constants.upButtonFontSize)
        firstPageButton.tintColor = .black
        firstPageButton.backgroundColor = UIColor(hex: Constants.darkGreen)
        firstPageButton.addTarget(self, action: #selector(switchToFirstScreen), for: .touchUpInside)
        
        secondPageButton.setTitle(Constants.secondButtonText, for: .normal)
        secondPageButton.setHeight(45)
        secondPageButton.layer.borderWidth = 1
        secondPageButton.layer.cornerRadius = Constants.buttonCornerRadius
        secondPageButton.titleLabel?.font = UIFont(name: Constants.tinosBold, size: Constants.upButtonFontSize)
        secondPageButton.tintColor = .black
        secondPageButton.backgroundColor = UIColor(hex: Constants.lightGreen)
        secondPageButton.addTarget(self, action: #selector(switchToSecondScreen), for: .touchUpInside)
        
        stackUpButtons.pinHorizontal(to: view, 30)
        stackUpButtons.pinTop(to: welcomeLabel.bottomAnchor, 15)
        
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
        view.addSubview(myAlarmsButton)
        
        let image = UIImage(named: Constants.alarmIcon)
        myAlarmsButton.configure(title: Constants.alarmButtonText, image: image)
        
        myAlarmsButton.pinLeft(to: createButton.trailingAnchor, Constants.alarmButtonLeft)
        myAlarmsButton.pinVertical(to: createButton)
        myAlarmsButton.pinRight(to: view.safeAreaLayoutGuide.trailingAnchor, Constants.alarmButtonLeft)
        
        
        myAlarmsButton.addTarget(self, action: #selector(goToMyAlarms), for: .touchUpInside)
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.pinTop(to: stackUpButtons.bottomAnchor, 5)
        tableView.pinLeft(to: view.leadingAnchor, 0)
        tableView.pinRight(to: view.trailingAnchor, 0)
        tableView.pinBottom(to: createButton.topAnchor, 5)
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 24, right: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(AlarmCardCell.self, forCellReuseIdentifier: AlarmCardCell.reuseIdentifier)
    }
    
    private func loadFirstPage() {
        currentPage = 0
        hasMorePages = true
        isLoading = true
        
        items = []
        alarms = []
        allItems = []
        allAlarms = []
        tableView.reloadData()
        
        switch currentScreenType {
        case .almostWakeUp:
            interactor.loadAlarms(
                Model.LoadAlarmMainScreen.Request(
                    page: currentPage,
                    limit: pageSize,
                    type: "ALMOST_WAKE_UP"
                )
            )
            
        case .wakeInAdvance:
            interactor.loadAlarms(
                Model.LoadAlarmMainScreen.Request(
                    page: currentPage,
                    limit: pageSize,
                    type: "WAKE_IN_ADVANCE"
                )
            )
        }
    }
    
    private func loadNextPageIfNeeded() {
        guard !isLoading, hasMorePages else { return }
        
        isLoading = true
        
        switch currentScreenType {
        case .almostWakeUp:
            interactor.loadAlarms(
                Model.LoadAlarmMainScreen.Request(
                    page: currentPage,
                    limit: pageSize,
                    type: "ALMOST_WAKE_UP"
                )
            )
            
        case .wakeInAdvance:
            interactor.loadAlarms(
                Model.LoadAlarmMainScreen.Request(
                    page: currentPage,
                    limit: pageSize,
                    type: "WAKE_IN_ADVANCE"
                )
            )
        }
    }
    
    func displayAlarms(_ vm: Model.LoadAlarmMainScreen.ViewModel) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.isLoading = false
            
            if let error = vm.errorMessage {
                self.showMessage(error, "Ошибка")
                return
            }
            
            if vm.page == 0 {
                self.allItems = vm.items
                self.allAlarms = vm.alarms
            } else {
                self.allItems.append(contentsOf: vm.items)
                self.allAlarms.append(contentsOf: vm.alarms)
            }
            
            self.items = self.allItems
            self.alarms = self.allAlarms
            
            self.hasMorePages = !vm.last
            self.currentPage = vm.page + 1
            
            self.tableView.reloadData()
        }
    }
    
    func displayRegistrationAnswer(_ vm: Model.RegisterUserToAlarm.ViewModel) {
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
            alarms = allAlarms
            tableView.reloadData()
            return
        }
        
        let filteredPairs = zip(allItems, allAlarms).filter { item, alarm in
            alarm.id.localizedCaseInsensitiveContains(trimmedQuery)
        }
        
        items = filteredPairs.map { $0.0 }
        alarms = filteredPairs.map { $0.1 }
        
        tableView.reloadData()
    }
    
    
    //MARK: - Target func
    @objc
    private func createButtonTapped() {
        let vc = CreateNewAlarmAssembly.build()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func goToMyAlarms() {
        let vc = MyAlarmsAssembly.build()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func switchToFirstScreen() {
        guard currentScreenType != .almostWakeUp else { return }
        
        currentScreenType = .almostWakeUp
        
        firstPageButton.backgroundColor = UIColor(hex: Constants.darkGreen)
        secondPageButton.backgroundColor = UIColor(hex: Constants.lightGreen)
        
        loadFirstPage()
    }
    
    @objc
    private func switchToSecondScreen() {
        guard currentScreenType != .wakeInAdvance else { return }
        
        currentScreenType = .wakeInAdvance
        
        secondPageButton.backgroundColor = UIColor(hex: Constants.darkGreen)
        firstPageButton.backgroundColor = UIColor(hex: Constants.lightGreen)
        
        loadFirstPage()
    }
}

extension AlarmFirstMainScreenViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let alarm = alarms[indexPath.row]
        
        switch currentScreenType {
        case .almostWakeUp:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: AlarmCardCell.reuseIdentifier,
                for: indexPath
            ) as? AlarmCardCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: item)
            
            cell.onJoinTap = { [weak self] in
                self?.interactor.registarUser(
                    Model.RegisterUserToAlarm.Request(
                        alarmId: alarm.id,
                        userId: UserDefaults.standard.string(forKey: UserDefaultsKeys.id)
                    )
                )
            }
            
            cell.onCardTap = { [weak self] in
                let vc = AlarmDetailsAssembly.build(alarm: alarm)
                vc.modalPresentationStyle = .overCurrentContext
                self?.present(vc, animated: true, completion: nil)
            }
            
            return cell
            
        case .wakeInAdvance:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: AlarmCardCell.reuseIdentifier,
                for: indexPath
            ) as? AlarmCardCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: item, true)
            
            cell.onJoinTap = { [weak self] in
                
                Task {
                    
                    let allowed = await AlarmPermissionManager.shared.requestPermission()
                    guard let self else { return }
                    
                    do {
                        guard allowed else {
                            await AlarmPermissionManager.shared.showDeniedAlert(from: self)
                            return
                        }
                        
                        self.interactor.registarUser(
                            Model.RegisterUserToAlarm.Request(
                                alarmId: alarm.id,
                                userId: UserDefaults.standard.string(forKey: UserDefaultsKeys.id)
                            )
                        )
                        
                    }
                }
                
            }
            
            cell.onCardTap = { [weak self] in
                let vc = AlarmDetailsAssembly.build(alarm: alarm)
                vc.modalPresentationStyle = .overCurrentContext
                self?.present(vc, animated: true, completion: nil)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let threshold = items.count - 5
        if indexPath.row == threshold {
            loadNextPageIfNeeded()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}
