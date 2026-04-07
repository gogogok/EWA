import UIKit
import FirebaseAuth

final class SettingsMainScreenViewController: UIViewController {
    
    typealias Model = SettingsMainScreenModel
    
    //MARK: - Constants
    private enum Constants {
        
        static let fatalError: String = "Ошибка создания"

        static let backgroundLeftRight: CGFloat = 50
        
        static let topImageTop: CGFloat = -17
        static let topImageRotate: CGFloat = 280
        static let topImageLeft: CGFloat = -220
        static let topImageHeight: CGFloat = 170
        
        static let stackButtonsTop: CGFloat = 50
        static let buttonFont: String = "RubikMonoOne-Regular"
        static let betweenButtonsTop: CGFloat = 20
        static let buttonCornerRadius: CGFloat = 10
        static let buttonLeftRight: CGFloat = 10
        
        static let avatarIconTopLeft: CGFloat = 40
        static let avatarIconSize: CGFloat = 120
        
        static let nameLabelFontSize: CGFloat = 20
        static let nameLabelTop: CGFloat = 60
        static let nameLabelHeight: CGFloat = 40
        static let nameLabelWidth: CGFloat = 160
        static let nameLabelLeft: CGFloat = 30
        static let nameLabelRight: CGFloat = 40
        static let nameLabelCornerRadius: CGFloat = 10
        
        static let achivementLabelFontSize: CGFloat = 15
        static let achivementLabelTop: CGFloat = 10
        static let achivementLabelHeight: CGFloat = 30
        static let achivementLabelWidth: CGFloat = 160
        static let achivementLabelLeft: CGFloat = 30
        static let achivementLabelRight: CGFloat = 70
        static let achivementLabelCornerRadius: CGFloat = 15
        
        static let achivementsText: String = "Достижения"
        static let achivementsImg : String = "achivements_button"
        
        static let changeProfileText: String = "Изменить профиль"
        static let changeProfileImg: String = "change_profile_button"
        
        static let blackListText: String = "Чёрный список"
        static let blackListImg: String = "black_list_button"
        
        static let purple: String = "#9F5FFC"
        static let lightPurple: String = "#D0B9FF"
        static let lightLightPurple: String = "#E8D8FF"
        static let green: String = "#40A27B"
    }
    
    //MARK: - Fields
    
    var interactor : SettingsMainScreenBusinessLogic
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
    
    var achievementsButton : ChooseMenuButton?
    var changeProfileButton :  ChooseMenuButton?
    var blackListButton : ChooseMenuButton?
    var nameLabel : PaddedLabel = PaddedLabel()
    var achivementsLabel : PaddedLabel = PaddedLabel()
    var name: String = "No name"
    var iconName: String = "fox"
    var achivement: String?
    
    lazy var avatarIcon : ProfileAvatarView = ProfileAvatarView(iconName: iconName)
    
    
    //MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for button in [achievementsButton, changeProfileButton, blackListButton] {
            button!.layer.cornerRadius = Constants.buttonCornerRadius
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    //MARK: - Lyfecycle
    init(interactor: SettingsMainScreenBusinessLogic) {
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
        configureAvatarIcon()
        configureNameLabel()
        achivement = "Нет достижений"
        configureAchivementLabel()
        configureButtons()
        configureActions()
    }
    
    private func configureBackgroudUI() {
        view.backgroundColor = .white
        view.addSubview(background)
        view.addSubview(top_image)
        
        view.backgroundColor = .white
        top_image.pinTop(to: view, Constants.topImageTop)
        top_image.pinLeft(to: view.leadingAnchor, Constants.topImageLeft)
        top_image.setHeight(Constants.topImageHeight)
        top_image.transform = CGAffineTransform(rotationAngle: CGFloat(.pi/180 * Constants.topImageRotate))
        
        
        background.pinCenter(to: view)
        background.pinHorizontal(to: view, Constants.backgroundLeftRight)
        
        view.sendSubviewToBack(top_image)
        view.sendSubviewToBack(background)
    }
    
    private func configureAvatarIcon() {
        view.addSubview(avatarIcon)
        avatarIcon.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.avatarIconTopLeft)
        avatarIcon.pinLeft(to: view.safeAreaLayoutGuide.leadingAnchor, Constants.avatarIconTopLeft)
        
        avatarIcon.setHeight(Constants.avatarIconSize)
        avatarIcon.setWidth(Constants.avatarIconSize)
    }
    
    private func configureNameLabel() {
        view.addSubview(nameLabel)
        nameLabel.text = name
        nameLabel.textAlignment = .center
        nameLabel.textColor = .black
        nameLabel.font = UIFont(name: "YanoneKaffeesatz-ExtraLight_Bold", size: Constants.nameLabelFontSize)
        nameLabel.numberOfLines = 2
        nameLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.nameLabelTop)
        nameLabel.pinLeft(to: avatarIcon.trailingAnchor, Constants.nameLabelLeft)
        nameLabel.pinRight(to: view.trailingAnchor, Constants.nameLabelRight)
        nameLabel.setHeight(Constants.nameLabelHeight)
        nameLabel.textAlignment = .left
        
        nameLabel.layer.borderWidth = 1
        nameLabel.layer.cornerRadius = Constants.nameLabelCornerRadius
        nameLabel.layer.masksToBounds = true
        nameLabel.backgroundColor = ColorChangindMethods.getHEXColor(hex: Constants.lightPurple)
    }
    
    private func configureAchivementLabel() {
        guard let achivement else {return}
        view.addSubview(achivementsLabel)
        achivementsLabel.text = achivement
        achivementsLabel.textAlignment = .center
        achivementsLabel.textColor = .black
        achivementsLabel.numberOfLines = 2
        achivementsLabel.pinTop(to: nameLabel.bottomAnchor, Constants.achivementLabelTop)
        achivementsLabel.pinLeft(to: avatarIcon.trailingAnchor, Constants.achivementLabelLeft)
        achivementsLabel.pinRight(to: view.trailingAnchor, Constants.achivementLabelRight)
        achivementsLabel.setHeight(Constants.achivementLabelHeight)
        achivementsLabel.textAlignment = .left
        achivementsLabel.font = UIFont(name: "YanoneKaffeesatz-ExtraLight_Regular", size: Constants.achivementLabelFontSize)
        
        achivementsLabel.layer.borderWidth = 1
        achivementsLabel.layer.cornerRadius = Constants.achivementLabelCornerRadius
        achivementsLabel.layer.masksToBounds = true
        achivementsLabel.backgroundColor = ColorChangindMethods.getHEXColor(hex: Constants.lightLightPurple)
    }
    
    private func configureButtons() {
        achievementsButton = ChooseMenuButton(imgName: Constants.achivementsImg, text: Constants.achivementsText, view: view)
        changeProfileButton = ChooseMenuButton(imgName: Constants.changeProfileImg, text: Constants.changeProfileText, view: view)
        blackListButton = ChooseMenuButton(imgName: Constants.blackListImg, text: Constants.blackListText, view: view)
        let buttonStackView = UIStackView(arrangedSubviews: [achievementsButton!, changeProfileButton!, blackListButton!])
        view.addSubview(buttonStackView)
        for button in [achievementsButton!, changeProfileButton!, blackListButton!] {
            button.configureButton()
        }
        
        
        buttonStackView.axis = .vertical
        buttonStackView.spacing = Constants.betweenButtonsTop
        buttonStackView.pinTop(to: avatarIcon.bottomAnchor, Constants.stackButtonsTop)
        buttonStackView.pinHorizontal(to: view, Constants.stackButtonsTop)
    }
    
    private func configureActions() {
        changeProfileButton?.addTarget(self, action: #selector(changeProfileTapped), for: .touchUpInside)
        blackListButton?.addTarget(self, action: #selector(blackListTapped), for: .touchUpInside)
        achievementsButton?.addTarget(self, action: #selector(achievementsTapped), for: .touchUpInside)
    }
    
    @objc
    private func changeProfileTapped() {
        let vc = ProfileSettingsAssembly.build()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func blackListTapped() {
        let vc = BlackListAssembly.build()
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }

    @objc
    private func achievementsTapped() {
        let vc = AchievementsAssembly.build()
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }

}

