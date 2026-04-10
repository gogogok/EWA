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
    
    //MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        configureUI()
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
    init(interactor:  AdventureMainScreenBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
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
        
        //createButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    private func configureEventsButton() {
        view.addSubview(myEventsButton)
        
        let image = UIImage(named: Constants.myEventsIcon)
        myEventsButton.configure(title: Constants.myEventsButtonText, image: image)
        
        myEventsButton.pinLeft(to: createButton.trailingAnchor, Constants.myEventsButtonLeft)
        myEventsButton.pinVertical(to: createButton)
        myEventsButton.pinRight(to: view.safeAreaLayoutGuide.trailingAnchor, Constants.myEventsButtonLeft)
        
        //myEventsButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
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
    
    //MARK: - Work with data
    private func loadData() {
        items = [.init(
            title: "Третьяковка",
            description: "Хочу сходить в Третьяковку",
            category: "Искусство",
            dateText: "завтра 08:00",
            avatarIconName: "wolf",
            buttonTitle: "Вперёд!"
        ),
        .init(
            title: "Кино",
            description: "Ищу компанию на вечерний фильм",
            category: "Развлечения",
            dateText: "сегодня 19:30",
            avatarIconName: "wolf",
            buttonTitle: "Вперёд!"
        )
    ]
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
        cell.configure(with: item)
        
        cell.onJoinTap = { [weak self] in
            print("Нажали на \(item.title)")
        }
        
        cell.onCardTap = { [weak self] in
            let vc = ShowMoreEventsAssembly.build()
            vc.modalPresentationStyle = .overCurrentContext
            self?.present(vc, animated: true, completion: nil)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        130
    }
}
