import UIKit
import FirebaseAuth

final class ProfileSettingsViewController: UIViewController {
    
    typealias Model = ProfileSettingsModel
    
    //MARK: - Constants
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
        
        static let avatarIconSize: CGFloat = 140
        static let avatarTop: CGFloat = 210
        
        static let nameLabelFontSize: CGFloat = 20
        static let nameLabelTop: CGFloat = 30
        static let nameLabelHeight: CGFloat = 40
        static let nameLabelWidth: CGFloat = 160
        static let nameLabelRight: CGFloat = 100
        static let nameLabelCornerRadius: CGFloat = 15
        
        static let doneButtonText: String = "Сохранить"
        static let doneButtonTop: CGFloat = 15
        static let doneButtonLeftRight: CGFloat = 150
        static let doneButtonCornerRadius: CGFloat = 15
        static let doneButtonFontSize: CGFloat = 15
        
        static let purple: String = "#9F5FFC"
        static let lightPurple: String = "#D0B9FF"
        static let lightLightPurple: String = "#E8D8FF"
        static let pinkLightPurple: String = "#EDD1FF"
        static let green: String = "#40A27B"
    }
    
    //MARK: - Fields
    
    var interactor : ProfileSettingsBusinessLogic
    let userWorker = UserProfileManager()
    
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
    var name: String = "No name"
    var iconName: String = "fox"
    lazy var avatarIcon : ProfileAvatarView = ProfileAvatarView(iconName: iconName, needEdition: true)
    
    var nameLabel : PaddedTextField = PaddedTextField()
    var doneButton: UIButton = UIButton(type: .system)
    
    //MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        getData()
        configureUI()
    }
    
    //MARK: - Lifecycle
    init(interactor: ProfileSettingsBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    private func getData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userInfo = userWorker.fetchById(id: uid)
        name = userInfo?.name ?? "Профиль"
        iconName = userInfo?.iconName ?? "fox"
        nameLabel.text = name
        avatarIcon.imageView.image = UIImage(named: iconName)
    }
    
    //MARK: - Configure UI
    private func configureUI() {
        configureBackgroudUI()
        configurebackButton()
        configureAvatar()
        configureNameLabel()
        configureDoneButton()
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
    
    private func configureAvatar() {
        view.addSubview(avatarIcon)
        avatarIcon.setWidth(Constants.avatarIconSize)
        avatarIcon.setHeight(Constants.avatarIconSize)
        
        avatarIcon.pinCenterX(to: view)
        avatarIcon.pinTop(to: customBackButton.bottomAnchor, -Constants.avatarTop)
        
        avatarIcon.onEditTap = { [weak self] in
            let vc = SetIconsAssembly.build() as! ProfileIconChooseScreenController
            vc.indexChosen = 0
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func configureNameLabel() {
        view.addSubview(nameLabel)
        nameLabel.text = name
        nameLabel.textAlignment = .center
        nameLabel.textColor = .black
        nameLabel.tintColor = .gray
        nameLabel.font = UIFont(name: "YanoneKaffeesatz-ExtraLight_Regular", size: Constants.nameLabelFontSize)
        nameLabel.pinTop(to: avatarIcon.bottomAnchor, Constants.nameLabelTop)
        nameLabel.pinHorizontal(to: view, Constants.nameLabelRight)
        nameLabel.setHeight(Constants.nameLabelHeight)
        nameLabel.textAlignment = .left
        
        nameLabel.layer.borderWidth = 1
        nameLabel.layer.cornerRadius = Constants.nameLabelCornerRadius
        nameLabel.layer.masksToBounds = true
        nameLabel.backgroundColor = ColorChangindMethods.getHEXColor(hex: Constants.pinkLightPurple)
    }
    
    private func configureDoneButton() {
        view.addSubview(doneButton)
        doneButton.setTitle(Constants.doneButtonText, for: .normal)
        doneButton.titleLabel?.textAlignment = .center
        doneButton.setTitleColor(.black, for: .normal)
        doneButton.titleLabel?.font = UIFont(name: "YanoneKaffeesatz-ExtraLight_Bold", size: Constants.doneButtonFontSize)
        doneButton.pinTop(to: nameLabel.bottomAnchor, Constants.doneButtonTop)
        doneButton.pinHorizontal(to: view, Constants.doneButtonLeftRight)
        
        doneButton.layer.borderWidth = 1
        doneButton.layer.cornerRadius = Constants.doneButtonCornerRadius
        doneButton.layer.masksToBounds = true
        doneButton.backgroundColor = ColorChangindMethods.getHEXColor(hex: Constants.lightLightPurple)
        
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - Target func
    @objc
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func doneButtonTapped() {
        let tabBar = TabScreenAssembly.build()
        interactor.loadMainScreen(Model.LoadProfileSettings.Request(viewController: tabBar, iconName: iconName, name: nameLabel.text!, indexChosen: 0))
    }
    
    //MARK: - Display func
    public func displayMainScreen( _ vm: Model.LoadProfileSettings.ViewModel) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        let vc = vm.viewController as! TabScreensController
        vc.selectedIndex = vm.indexChosen
        window.rootViewController = vc
        window.makeKeyAndVisible()
        
        UIView.transition(
            with: window,
            duration: 0.25,
            options: .transitionCrossDissolve,
            animations: nil
        )
    }
    
}

