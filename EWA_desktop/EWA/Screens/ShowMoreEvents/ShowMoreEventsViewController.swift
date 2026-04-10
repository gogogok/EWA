import UIKit

final class ShowMoreEventsViewController: UIViewController {
    
    typealias Model =  ShowMoreEventsModel
    
    //MARK: - Constants
    private enum Constants {
        static let fatalError: String = "Ошибка создания"
        
        static let viewTopInset: CGFloat = 60
        static let viewBottomInset: CGFloat = 190
        static let viewLeftRightInset: CGFloat = 30
        static let viewCornerRadius: CGFloat = 20
        
        static let backButtonWidthConstant: CGFloat = 2.1
        static let backButtonTop: CGFloat = -60
        
        static let avatarIconSize: CGFloat = 140
        static let avatarIconTop: CGFloat = 20
        static let avatarIconLeft: CGFloat = 20
        
        static let purple: String = "#9F5FFC"
        static let lightPurple: String = "#D0B9FF"
        static let lightLightPurple: String = "#E8D8FF"
        static let pinkLightPurple: String = "#EDD1FF"
        static let green: String = "#40A27B"
    }
    
    //MARK: - Fields
    
    var interactor :  ShowMoreEventsBusinessLogic
    
    var backView: UIView = UIView()
    let customBackButton = UIButton(type: .system)
    
    var avatarIcon = ProfileAvatarView(iconName: "wolf")
    
    
    //MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configurebackButton()
        configureAvatar()
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //MARK: - Lyfecycle
    init(interactor:  ShowMoreEventsBusinessLogic) {
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
    
    private func configurebackButton() {
        let img = UIImage(named: "close_button")?.withRenderingMode(.alwaysOriginal)
        customBackButton.setImage(img, for: .normal)
        customBackButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        customBackButton.imageView?.contentMode = .scaleAspectFit
        
        view.addSubview(customBackButton)
        let viewWidth: CGFloat = view.frame.width
        customBackButton.pinTop(to: view.topAnchor, Constants.backButtonTop)
        customBackButton.setWidth(viewWidth / Constants.backButtonWidthConstant)
        customBackButton.pinRight(to: view.trailingAnchor)
    }
    
    private func configureAvatar() {
        view.addSubview(avatarIcon)
        
        avatarIcon.setWidth(Constants.avatarIconSize)
        avatarIcon.setHeight(Constants.avatarIconSize)
        
        avatarIcon.pinTop(to: backView.topAnchor, Constants.avatarIconTop)
        avatarIcon.pinLeft(to: backView.leadingAnchor, Constants.avatarIconLeft)
    }
    
    //MARK: - Target func
    @objc
    func goBack() {
        dismiss(animated: true)
    }
    
    
}

