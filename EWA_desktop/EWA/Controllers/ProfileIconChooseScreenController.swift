//
//  ProfileIconChooseScreen.swift
//  EWA
//
//  Created by Дарья Жданок on 28.01.26.
//

//

import UIKit
import FirebaseAuth

class ProfileIconChooseScreenController : UIViewController {
    
    typealias Model = EWAModel
    
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
        
        static let сhooseIconLabelText: String = "Выбери новую аватарку! "
        static let сhooseIconLabelFontSize: CGFloat = 20
        static let сhooseIconLabelTop: CGFloat = 170
        static let сhooseIconLabelLeftRight: CGFloat = 60
        static let сhooseIconLabelCornerRadius: CGFloat = 10
        
        static let avatarsContainerLeftRight: CGFloat = 10
        static let avatarsContainerTop: CGFloat = 20
        static let gridLeftRight: CGFloat = 20
        
        static let iconCornerConstant: CGFloat = 81
        static let iconHeightWidthConstant: CGFloat = 2.5
        
        static let purple: String = "#9F5FFC"
        static let lightPurple: String = "#D0B9FF"
        static let lightLightPurple: String = "#E8D8FF"
        static let green: String = "#40A27B"
        
        static let durationPfAnimation: CGFloat = 0.15
        static let usingSpringWithDamping: CGFloat = 0.8
        static let initialSpringVelocity : CGFloat = 0.4
        static let scaleForTransform: CGFloat = 1.2
        static let alfaBorder: CGFloat = 0.5
        static let plusBorderWidth: CGFloat = 0.3
        
        static let iconDescriptionLabelFontSize: CGFloat = 16
        static let iconDescriptionLabelTop: CGFloat = 20
        static let iconDescriptionLabelLeftRight: CGFloat = 30
        static let iconDescriptionLabelCornerRadius: CGFloat = 20
        
        static let crowText: String = "Наблюдателен(на) и умен(на). Замечаешь то, что скрыто"
        static let foxText: String = "Хитрость и гибкость. Всегда находишь выход из ситуации"
        static let wolfText: String = "Силен(ьна) духом. Действуешь уверенно и не сдаёшься"
        static let squirrelText: String = "Больше энергии! Готов(а) действовать прямо сейчас"
        
        static let doneButtonText: String = "Выбрать"
        static let doneButtonTop : CGFloat = 15
        static let doneButtonLeftRight: CGFloat = 150
    }
    
    //MARK: - Fields
    
    var interactor : SetIconBusinessLogic
    
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
    
    let bottom_image: UIImageView = {
        let label = UIImageView()
        label.image = UIImage(named: "left_bottom_registration")
        label.contentMode = .scaleAspectFit
        label.tintColor = .white
        return label
    }()
    
    private lazy var avatarsGrid = AdaptiveGridStackView(
        columns: 2,
        spacing: Constants.gridLeftRight
    )
    
    private let avatarsContainer: UIView = { let view = UIView()
        view.backgroundColor = UIColor(hex: Constants.green)
        view.layer.cornerRadius = 24
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.18
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        return view
    }()
    
    private lazy var fox = makeAvatarImageView(named: "fox")
    private lazy var squirrel = makeAvatarImageView(named: "squirrel")
    private lazy var wolf = makeAvatarImageView(named: "wolf")
    private lazy var crow = makeAvatarImageView(named: "crow")
    

    
    let customBackButton = UIButton(type: .system)
    var сhooseIconLabel: PaddedLabel = PaddedLabel()
    var choosenIcon :UIView?
    var iconDescriptionLabel: PaddedLabel = PaddedLabel()
    var doneButton: UIButton = UIButton(type: .system)
    
    var iconDescriptionLabelText: String = " Кто же ты сегодня..."
    var selectedIcon: String = "fox"
    
    //MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        [fox, squirrel, wolf, crow].forEach {
            $0.layer.cornerRadius = Constants.iconCornerConstant
        }
    }
    
    //MARK: - Lyfecycle
    init(interactor: SetIconBusinessLogic) {
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
        configurebackButton()
        configureChooseIconLabel()
        configureIconsContainerView()
        configureDescriptionLabel()
        configureDoneButton()
    }
    
    private func configureBackgroudUI() {
        view.addSubview(background)
        view.addSubview(top_image)
        view.addSubview(bottom_image)
        
        view.backgroundColor = .white
        top_image.pinTop(to: view, Constants.topImageTop)
        top_image.pinLeft(to: view.leadingAnchor, Constants.topImageLeft)
        top_image.setHeight(Constants.topImageHeight)
        
        bottom_image.pinBottom(to: view.bottomAnchor, Constants.bottonImageHBottom)
        bottom_image.pinLeft(to: view.leadingAnchor)
        bottom_image.setHeight(Constants.bottonImageHeight)
        bottom_image.setWidth(Constants.bottonImageHeight)
        
        background.pinCenter(to: view)
        background.pinHorizontal(to: view, Constants.backgroundLeftRight)
        
        view.sendSubviewToBack(top_image)
        view.sendSubviewToBack(bottom_image)
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
    
    private func configureChooseIconLabel() {
        view.addSubview(сhooseIconLabel)
        сhooseIconLabel.text = Constants.сhooseIconLabelText
        сhooseIconLabel.textAlignment = .center
        сhooseIconLabel.textColor = .black
        сhooseIconLabel.font = UIFont(name: "YanoneKaffeesatz-ExtraLight_Regular", size: Constants.сhooseIconLabelFontSize)
        сhooseIconLabel.pinTop(to: view, Constants.сhooseIconLabelTop)
        сhooseIconLabel.pinHorizontal(to: view, Constants.сhooseIconLabelLeftRight)
        
        сhooseIconLabel.layer.borderWidth = 1
        сhooseIconLabel.layer.cornerRadius = Constants.сhooseIconLabelCornerRadius
        сhooseIconLabel.layer.masksToBounds = true
        сhooseIconLabel.backgroundColor = ColorChangindMethods.getHEXColor(hex: Constants.lightPurple)
    }
    
    private func configureIconsContainerView() {
        view.addSubview(avatarsContainer)

        avatarsContainer.pinTop(to: сhooseIconLabel.bottomAnchor, Constants.avatarsContainerTop)
        avatarsContainer.pinHorizontal(to: view, Constants.avatarsContainerLeftRight)
        avatarsContainer.addSubview(avatarsGrid)

        avatarsGrid.pinHorizontal(to: avatarsContainer, Constants.gridLeftRight)
        avatarsGrid.pinTop(to: avatarsContainer.topAnchor, Constants.gridLeftRight)
        avatarsGrid.pinBottom(to: avatarsContainer.bottomAnchor, Constants.gridLeftRight)

        let items: [(UIImageView, String)] = [
            (fox, "fox"),
            (squirrel, "squirrel"),
            (crow, "crow"),
            (wolf, "wolf")
        ]

        items.forEach { iv, id in
            iv.accessibilityIdentifier = id
            addTapFunc(to: iv)
        }

        avatarsGrid.setItems(items.map { $0.0 })
    }

    
    private func configureDescriptionLabel() {
        view.addSubview(iconDescriptionLabel)
        iconDescriptionLabel.text = iconDescriptionLabelText
        iconDescriptionLabel.textAlignment = .center
        iconDescriptionLabel.textColor = .black
        iconDescriptionLabel.font = UIFont(name: "YanoneKaffeesatz-ExtraLight_Regular", size: Constants.iconDescriptionLabelFontSize)
        iconDescriptionLabel.pinTop(to: avatarsContainer.bottomAnchor, Constants.iconDescriptionLabelTop)
        iconDescriptionLabel.pinHorizontal(to: view, Constants.iconDescriptionLabelLeftRight)
        
        iconDescriptionLabel.layer.borderWidth = 1
        iconDescriptionLabel.layer.cornerRadius = Constants.iconDescriptionLabelCornerRadius
        iconDescriptionLabel.layer.masksToBounds = true
        iconDescriptionLabel.backgroundColor = ColorChangindMethods.getHEXColor(hex: Constants.lightPurple)
    }
    
    private func configureDoneButton() {
        view.addSubview(doneButton)
        doneButton.setTitle(Constants.doneButtonText, for: .normal)
        doneButton.titleLabel?.textAlignment = .center
        doneButton.setTitleColor(.black, for: .normal)
        doneButton.titleLabel?.font = UIFont(name: "YanoneKaffeesatz-ExtraLight_Bold", size: Constants.iconDescriptionLabelFontSize)
        doneButton.pinTop(to: iconDescriptionLabel.bottomAnchor, Constants.doneButtonTop)
        doneButton.pinHorizontal(to: view, Constants.doneButtonLeftRight)
        
        doneButton.layer.borderWidth = 1
        doneButton.layer.cornerRadius = Constants.сhooseIconLabelCornerRadius
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
    private func chooseIcon(_ gesture: UITapGestureRecognizer) {
        guard let tappedView = gesture.view else {return}
        
        if choosenIcon !== tappedView {
            deselectCurrentAvatar()
        }
        
        choosenIcon = tappedView
        
        UIView.animate(withDuration: Constants.durationPfAnimation,
                       delay: 0,
                       usingSpringWithDamping: Constants.usingSpringWithDamping,
                       initialSpringVelocity: Constants.initialSpringVelocity,
                       options: [.allowUserInteraction]) {
            self.choosenIcon?.transform = CGAffineTransform(scaleX: Constants.scaleForTransform, y: Constants.scaleForTransform)
            self.choosenIcon?.layer.borderColor = UIColor.white.withAlphaComponent(Constants.alfaBorder).cgColor
            self.choosenIcon?.layer.borderWidth += 2
            self.reloadTextLabel(self.choosenIcon?.accessibilityIdentifier)
        }
    }
    
    @objc
    private func doneButtonTapped() {
        let tabBar = TabScreenAssembly.build()
        interactor.loadMainScreen(Model.StartMainScreen.Request(viewController: tabBar, iconName: selectedIcon))
    }
    
    //MARK: - display func
    
    public func displayMainScreen( _ vm: Model.StartMainScreen.ViewModel) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        window.rootViewController = vm.viewController
        window.makeKeyAndVisible()
        
        UIView.transition(
            with: window,
            duration: 0.25,
            options: .transitionCrossDissolve,
            animations: nil
        )
    }
    
    //MARK: - Help func
    private func makeAvatarImageView(named: String) -> UIImageView {
        let iv = UIImageView(image: UIImage(named: named))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 0
        iv.isUserInteractionEnabled = true
        return iv
    }
    
    private func addTapFunc(to iv: UIImageView) {
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(chooseIcon(_:)))
        iv.addGestureRecognizer(tap)
    }
    
    private func deselectCurrentAvatar() {
        guard let current = choosenIcon else { return }
        
        UIView.animate(withDuration: Constants.durationPfAnimation) {
            current.transform = .identity
        }
        current.layer.borderWidth = 0
        choosenIcon = nil
    }
    
    private func reloadTextLabel(_ animal: String?) {
        guard let animal = animal else { return }
        switch animal {
        case "fox" :
            iconDescriptionLabel.text = Constants.foxText
        case "crow":
            iconDescriptionLabel.text = Constants.crowText
        case "wolf":
            iconDescriptionLabel.text = Constants.wolfText
        case "squirrel":
            iconDescriptionLabel.text = Constants.squirrelText
        default:
            return
        }
        selectedIcon = animal
    }
    
}

