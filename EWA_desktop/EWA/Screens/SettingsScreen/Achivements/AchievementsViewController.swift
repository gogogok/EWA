import UIKit

final class HitTestInsetButton: UIButton {
    var hitTestInsets = UIEdgeInsets.zero

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let bounds = self.bounds
        let hitFrame = bounds.inset(by: hitTestInsets)
        return hitFrame.contains(point)
    }
}

final class AchievementsViewController: UIViewController {
    
    typealias Model = AchievementsModel
    
    //MARK: - Constants
    private enum Constants {
        static let fatalError: String = "Ошибка создания"
        
        static let viewTopInset: CGFloat = 60
        static let viewBottomInset: CGFloat = 190
        static let viewLeftRightInset: CGFloat = 30
        static let viewCornerRadius: CGFloat = 20
        
        static let backButtonWidthConstant: CGFloat = 2.1
        static let backButtonTop: CGFloat = -60
        
        static let purple: String = "#9F5FFC"
        static let lightPurple: String = "#D0B9FF"
        static let lightLightPurple: String = "#E8D8FF"
        static let pinkLightPurple: String = "#EDD1FF"
        static let green: String = "#40A27B"
        
        static let topFont: String = "YanoneKaffeesatz-ExtraLight_Regular"
    }
    
    private struct AchievementItem {
        let id: AchievementID
        let iconName: String
        let description: String
    }

    private let achievements: [AchievementItem] = [
        
        AchievementItem(
            id: .events5,
            iconName: "achv_5_events",
            description: "Вы поучаствовали в 5 мероприятиях"
        ),
        
        AchievementItem(
            id: .events10,
            iconName: "achv_10_events",
            description: "Вы поучаствовали в 10 мероприятиях"
        ),
        
        AchievementItem(
            id: .events50,
            iconName: "achv_50_events",
            description: "Вы поучаствовали в 50 мероприятиях"
        ),
        
        AchievementItem(
            id: .wake5,
            iconName: "achv_5_wake",
            description: "Вы разбудили 5 человек"
        ),
        
        AchievementItem(
            id: .wake10,
            iconName: "achv_10_wake",
            description: "Вы разбудили 10 человек"
        ),
        
        AchievementItem(
            id: .wake50,
            iconName: "achv_50_wake",
            description: "Вы разбудили 50 человек"
        ),
        
        AchievementItem(
            id: .study2Hours,
            iconName: "achv_2h_study",
            description: "Вы учились 2 часа подряд"
        ),
        
        AchievementItem(
            id: .messages100,
            iconName: "achv_100_msgs",
            description: "Вы отправили 100 сообщений в чатах"
        )
    ]
    
    //MARK: - Fields
    
    var interactor : AchievementsBusinessLogic
    
    var backView: UIView = UIView()
    let customBackButton = HitTestInsetButton(type: .system)
    var onSelectAchievement: ((String) -> Void)?
    private var selectedDescription: String?
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Достижения"
        label.font = UIFont(name: Constants.topFont, size: 30)
        return label
    }()
    
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    private let descriptionLabel = UILabel()
    private let selectTitleButton = UIButton(type: .system)
    private let itemsPerRow = 3
    private let itemSpacing: CGFloat = 8
    private let rowSpacing: CGFloat = 12
    
    
    //MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configurebackButton()
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let midPoint = CGPoint(x: 0, y: titleLabel.bounds.midY)
        let titleMidYInView = titleLabel.convert(midPoint, to: view).y
        let buttonFrameInView = customBackButton.convert(customBackButton.bounds, to: view)
        let desiredBottomCut = buttonFrameInView.maxY - titleMidYInView
        let extraBottomInset = max(0, desiredBottomCut + 6)
        var insets = customBackButton.hitTestInsets
        insets.bottom = extraBottomInset
        customBackButton.hitTestInsets = insets
    }
    
    //MARK: - Lyfecycle
    init(interactor: AchievementsBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    //MARK: - Configure UI
    private func configureUI() {
        configureView()
        configureTitleLabel()
        configureAchievements()
    }
    
    private func configureView() {
        view.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        view.addSubview(backView)
        backView.backgroundColor = UIColor(hex: Constants.pinkLightPurple)
        backView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.viewTopInset)
        backView.pinBottom(to: view, Constants.viewBottomInset)
        backView.pinHorizontal(to: view, Constants.viewLeftRightInset)
        
        backView.layer.cornerRadius = Constants.viewCornerRadius
    }
    
    private func configureTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.pinTop(to: backView.topAnchor, 40)
        titleLabel.pinCenterX(to: backView)
    }
    
    private func configurebackButton() {
        let img = UIImage(named: "close_button")?.withRenderingMode(.alwaysOriginal)
        customBackButton.setImage(img, for: .normal)
        customBackButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        customBackButton.imageView?.contentMode = .scaleAspectFit
        customBackButton.hitTestInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        
        view.addSubview(customBackButton)
        let viewWidth: CGFloat = view.frame.width
        customBackButton.pinTop(to: view.topAnchor, Constants.backButtonTop)
        customBackButton.setWidth(viewWidth / Constants.backButtonWidthConstant)
        customBackButton.pinRight(to: view.trailingAnchor)
    }
    
    // MARK: - Achievements UI
    private func configureAchievements() {
        backView.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        contentStackView.distribution = .fill
        contentStackView.spacing = rowSpacing
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStackView)

        descriptionLabel.numberOfLines = 0
        descriptionLabel.alpha = 0
        descriptionLabel.font = UIFont(name: Constants.topFont, size: 20)
        descriptionLabel.adjustsFontForContentSizeCategory = true
        descriptionLabel.textColor = .black
        descriptionLabel.textAlignment = .center
        descriptionLabel.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        descriptionLabel.layer.cornerRadius = 18
        descriptionLabel.clipsToBounds = true
        descriptionLabel.setHeight(36)
        descriptionLabel.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        descriptionLabel.layer.borderWidth = 1
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        backView.addSubview(descriptionLabel)

        backView.addSubview(selectTitleButton)
        selectTitleButton.setTitle("Выбрать титул", for: .normal)
        selectTitleButton.setTitleColor(.white, for: .normal)
        selectTitleButton.backgroundColor = UIColor(hex: Constants.purple)
        selectTitleButton.layer.cornerRadius = 12
        selectTitleButton.titleLabel?.font = UIFont(name: Constants.topFont, size: 18)
        selectTitleButton.translatesAutoresizingMaskIntoConstraints = false
        selectTitleButton.addTarget(self, action: #selector(selectTitleTapped), for: .touchUpInside)
        selectTitleButton.isHidden = true
        selectTitleButton.isEnabled = false

        scrollView.pinTop(to: titleLabel.bottomAnchor, 20)
        scrollView.pinLeft(to: backView, 16)
        scrollView.pinRight(to: backView, 16)
        scrollView.pinBottom(to: descriptionLabel.topAnchor, 12)

        contentStackView.pinTop(to: scrollView.contentLayoutGuide.topAnchor)
        contentStackView.pinLeft(to: scrollView.contentLayoutGuide.leadingAnchor)
        contentStackView.pinRight(to: scrollView.contentLayoutGuide.trailingAnchor)
        contentStackView.pinBottom(to: scrollView.contentLayoutGuide.bottomAnchor)
        contentStackView.pinWidth(to: scrollView.frameLayoutGuide.widthAnchor)

        descriptionLabel.pinLeft(to: backView, 16)
        descriptionLabel.pinRight(to: backView, 16)
        descriptionLabel.pinBottom(to: selectTitleButton.topAnchor, 12)
        descriptionLabel.pinCenterX(to: backView)

        selectTitleButton.pinLeft(to: backView, 16)
        selectTitleButton.pinRight(to: backView, 16)
        selectTitleButton.pinBottom(to: backView, 16)
        selectTitleButton.setHeight(44)

        buildGrid()
    }

    private func buildGrid() {
        for v in contentStackView.arrangedSubviews { contentStackView.removeArrangedSubview(v); v.removeFromSuperview() }

        let total = achievements.count
        let rows = Int(ceil(Double(total) / Double(itemsPerRow)))

        for rowIndex in 0..<rows {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.alignment = .fill
            rowStack.distribution = .fillEqually
            rowStack.spacing = itemSpacing
            rowStack.translatesAutoresizingMaskIntoConstraints = false

            let start = rowIndex * itemsPerRow
            let end = min(start + itemsPerRow, total)

            for i in start..<end {
                let item = achievements[i]
                let isUnlocked = UserDefaultsAchievementsStore().isAchievementUnlocked(item.id)
                let button = makeItemButton(iconName: item.iconName, description: item.description, isUnlocked: isUnlocked)
                rowStack.addArrangedSubview(button)
            }

            let itemsInRow = end - start
            if itemsInRow < itemsPerRow {
                for _ in 0..<(itemsPerRow - itemsInRow) {
                    let spacer = UIView()
                    spacer.translatesAutoresizingMaskIntoConstraints = false
                    rowStack.addArrangedSubview(spacer)
                }
            }

            contentStackView.addArrangedSubview(rowStack)
        }
    }

    private func makeItemButton(iconName: String, description: String, isUnlocked: Bool) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.heightAnchor.constraint(equalTo: container.widthAnchor).isActive = true

        let avatar = ProfileAvatarView(iconName: iconName)
        avatar.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(avatar)
        avatar.pin(to: container)

        if !isUnlocked {
            avatar.alpha = 0.4
            let lock = UIImageView(image: UIImage(systemName: "lock.fill"))
            lock.tintColor = .black
            lock.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(lock)
            lock.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
            lock.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        }

        avatar.onTap = { [weak self] _ in
            guard let self = self else { return }
            self.showDescription(description)
            guard isUnlocked else { return }
            self.selectedDescription = description
            self.selectTitleButton.isEnabled = true
            if self.selectTitleButton.isHidden {
                self.selectTitleButton.alpha = 0
                self.selectTitleButton.isHidden = false
                UIView.animate(withDuration: 0.25) {
                    self.selectTitleButton.alpha = 1
                }
            }
        }

        return container
    }

    private func showDescription(_ text: String) {
        descriptionLabel.text = text
        if descriptionLabel.alpha == 0 {
            descriptionLabel.alpha = 0
            UIView.animate(withDuration: 0.25) {
                self.descriptionLabel.alpha = 1
            }
        }
    }
    
    //MARK: - Target func
    @objc
    private func selectTitleTapped() {
        guard let text = selectedDescription else { return }
        var title = ""
        switch text {
        case "Вы поучаствовали в 5 мероприятиях":
            title = AchievementsEnum.eventFive
        case "Вы поучаствовали в 10 мероприятий":
            title = AchievementsEnum.eventTen
        case "Вы поучаствовали в 50 мероприятиях":
            title = AchievementsEnum.eventFifty
        case "Вы разбудили 5 человек":
            title = AchievementsEnum.clockFive
        case "Вы разбудили 10 человек":
            title = AchievementsEnum.clockTen
        case "Вы разбудили 50 человек":
            title = AchievementsEnum.clockFifty
        case "Вы отправили 100 сообщений в чатах":
            title = AchievementsEnum.massage
        case "Вы учились 2 часа подряд":
            title = AchievementsEnum.study
        default:
            title = "Нет достижений"
        }
        onSelectAchievement?(title)
        dismiss(animated: true)
    }

    @objc
    func goBack() {
        dismiss(animated: true)
    }

}
