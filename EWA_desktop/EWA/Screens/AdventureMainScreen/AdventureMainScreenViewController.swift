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
        
        static let welcomeLabelText: String = "Хочешь на мероприятие?\nНайди с кем пойти! "
        static let welcomeLabelFontSize: CGFloat = 28
        static let welcomeLabelTop: CGFloat = 120
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
        static let searchLeftRight: CGFloat = 10
        
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
    
    //MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
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
    
}

