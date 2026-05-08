import UIKit

final class AlarmDetailsViewController: UIViewController {
    
    typealias Model =  AlarmDetailsModel
    
    //MARK: - Constants
    private enum Constants {
        static let fatalError: String = "Ошибка создания"
        
        static let viewTopInset: CGFloat = 60
        static let viewBottomInset: CGFloat = 170
        static let viewLeftRightInset: CGFloat = 30
        static let viewCornerRadius: CGFloat = 20
        
        static let backButtonWidthConstant: CGFloat = 2.1
        static let backButtonTop: CGFloat = -80
        
        static let avatarIconSize: CGFloat = 140
        static let avatarIconTop: CGFloat = 20
        static let avatarIconLeft: CGFloat = 20
        
        static let purple: String = "#9F5FFC"
        static let lightPurple: String = "#D0B9FF"
        static let lightLightPurple: String = "#E8D8FF"
        static let pinkLightPurple: String = "#EDD1FF"
        static let green: String = "#40A27B"
        
        static let defaultAvatarIconName: String = "wolf"
        
        static let cornerRadius: CGFloat = 22
        static let borderWidth: CGFloat = 2
        
        static let contentInset: CGFloat = 5
        static let horizontalSpacing: CGFloat = 5
        
        static let leftColumnWidth: CGFloat = 88
        static let rightColumnWidth: CGFloat = 90
        
        static let avatarTop: CGFloat = 0
        static let avatarSize: CGFloat = 60
        
        static let creatornameTop: CGFloat = 20
        static let creatornameLeft: CGFloat = 10
        static let creatornameRight: CGFloat = 10
        static let creatornameHeight: CGFloat = 35
        static let creatornameCornerRadius: CGFloat = 11
        static let creatornameFontSize: CGFloat = 25
        
        static let categoryTop: CGFloat = 10
        static let categoryLeft: CGFloat = 0
        static let categoryRight: CGFloat = 70
        static let categoryHeight: CGFloat = 28
        static let categoryCornerRadius: CGFloat = 13
        static let categoryTextColor: UIColor = .white
        static let categoryFontSize: CGFloat = 16
        static let categoryBackgroundColor: UIColor = .black
        
        static let nameTop: CGFloat = 10
        static let nameLeft: CGFloat = 0
        static let nameRight: CGFloat = 60
        static let nameHeight: CGFloat = 50
        static let nameCornerRadius: CGFloat = 11
        static let nameFontSize: CGFloat = 30
        
        static let namingTop: CGFloat = 4
        static let namingLeftRight: CGFloat = 2
        static let namingHeight: CGFloat = 40
        static let namingFontSize: CGFloat = 30
        
        static let dateFontSize: CGFloat = 22
        static let dateTop: CGFloat = 10
        static let dateLeft: CGFloat = 10
        static let dateRight: CGFloat = 70
        static let dateHeight: CGFloat = 28
        static let dateCornerRadius: CGFloat = 11
        static let dateTextColor: UIColor = .white

        
        static let descriptionFontSize: CGFloat = 24
        static let descriptionTop: CGFloat = 20
        static let descriptionLeft: CGFloat = 10
        static let descriptionRight: CGFloat = 70
        static let descriptionHeight: CGFloat = 28
        static let descriptionCornerRadius: CGFloat = 11
        
        static let descriptionLabelFontSize: CGFloat = 15
        static let descriptionLabelTop: CGFloat = 5
        static let descriptionLabelLeft: CGFloat = 30
        static let descriptionLabelHeight: CGFloat = 120
        
        static let labelCornerradius: CGFloat = 10

        static let tinosRegular : String = "Tinos-Regular"
        static let tinosBold : String = "Tinos-Bold"
        static let yanoneKaffeesatzRegular: String = "YanoneKaffeesatz-ExtraLight_Regular"
        static let yanoneKaffeesatzBold: String = "YanoneKaffeesatz-ExtraLight_Bold"
    }
    
    //MARK: - Fields
    
    var interactor :  AlarmDetailsBusinessLogic
    
    var backView: UIView = UIView()
    let customBackButton = UIButton(type: .system)
    
    var alarm: AlarmResponse?
    
    var avatarIcon = ProfileAvatarView(iconName: "wolf")
    
    var creatorName : PaddedLabel = {
        let label = PaddedLabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: Constants.yanoneKaffeesatzBold, size: Constants.creatornameFontSize)
        label.numberOfLines = 1
        label.backgroundColor = UIColor(hex: Constants.lightLightPurple)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.layer.masksToBounds = true
        label.layer.cornerRadius = Constants.creatornameCornerRadius
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1.0
        return label
    }()
    
    private let tagName : PaddedLabel = {
        let label = PaddedLabel()
        label.textColor = Constants.categoryTextColor
        label.backgroundColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: Constants.tinosBold, size: Constants.categoryFontSize)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.layer.masksToBounds = true
        label.layer.cornerRadius = Constants.categoryCornerRadius
        return label
    }()
    
    var date : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: Constants.tinosBold, size: Constants.dateFontSize)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    var time : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: Constants.tinosBold, size: Constants.dateFontSize - 2)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    
    var descriptionText : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Описание:"
        label.font = UIFont(name: Constants.yanoneKaffeesatzBold, size: Constants.descriptionFontSize)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    var descriptionLabel : PaddedLabelPinTop = {
        let label = PaddedLabelPinTop()
        label.backgroundColor = .white
        label.textColor = .black
        label.font = UIFont(name: Constants.yanoneKaffeesatzBold, size: Constants.descriptionLabelFontSize)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.layer.masksToBounds = true
        label.minimumScaleFactor = 0.8
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.cornerRadius = Constants.labelCornerradius
        return label
    }()
    
    var commentText : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Комментарий:"
        label.font = UIFont(name: Constants.yanoneKaffeesatzBold, size: Constants.descriptionFontSize)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    var commentLabel : PaddedLabelPinTop = {
        let label = PaddedLabelPinTop()
        label.backgroundColor = .white
        label.textColor = .black
        label.font = UIFont(name: Constants.yanoneKaffeesatzBold, size: Constants.descriptionLabelFontSize)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.layer.borderWidth = 1
        label.layer.masksToBounds = true
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.cornerRadius = Constants.labelCornerradius
        return label
    }()
    
    
    //MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        displayAlarm(alarm)
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    //MARK: - Lyfecycle
    init(interactor:  AlarmDetailsBusinessLogic, alarm: AlarmResponse) {
        self.interactor = interactor
        self.alarm = alarm
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    //MARK: - Configure UI
    private func configureUI() {
        configureView()
        configurebackButton()
        configureAvatar()
        configureProfileData()
        configureAlarmInformation()
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
    
    private func configureProfileData() {
        view.addSubview(creatorName)
        view.addSubview(tagName)
        view.addSubview(date)
        view.addSubview(time)
        
        creatorName.pinTop(to: avatarIcon.topAnchor, Constants.creatornameTop)
        creatorName.pinLeft(to: avatarIcon.trailingAnchor, Constants.creatornameLeft)
        creatorName.pinRight(to: backView.trailingAnchor, Constants.creatornameRight)
        creatorName.setHeight(Constants.creatornameHeight)
        
        tagName.pinTop(to: creatorName.bottomAnchor, Constants.categoryTop)
        tagName.pinLeft(to: creatorName.leadingAnchor)
        tagName.pinRight(to: backView.trailingAnchor, Constants.categoryRight)
        tagName.setHeight(Constants.categoryHeight)
        
        date.pinTop(to: tagName.bottomAnchor, Constants.namingTop)
        date.pinLeft(to: tagName.leadingAnchor)
        
        time.pinTop(to: date.bottomAnchor, 2)
        time.pinLeft(to: tagName.leadingAnchor)
    }
    
    private func configureAlarmInformation() {
        view.addSubview(descriptionText)
        view.addSubview(descriptionLabel)
        view.addSubview(commentText)
        view.addSubview(commentLabel)
        
        descriptionText.pinTop(to: avatarIcon.bottomAnchor, Constants.dateTop)
        descriptionText.pinLeft(to: avatarIcon.leadingAnchor, Constants.dateLeft)
        
        descriptionLabel.pinTop(to: descriptionText.bottomAnchor, Constants.descriptionLabelTop)
        descriptionLabel.pinHorizontal(to: backView, Constants.descriptionLabelLeft)
        descriptionLabel.setHeight(Constants.descriptionLabelHeight)
        
        commentText.pinTop(to: descriptionLabel.bottomAnchor, Constants.descriptionTop)
        commentText.pinLeft(to: descriptionLabel.leadingAnchor)
        
        commentLabel.pinTop(to: commentText.bottomAnchor, Constants.descriptionLabelTop)
        commentLabel.pinHorizontal(to: backView, Constants.descriptionLabelLeft)
        commentLabel.setHeight(Constants.descriptionLabelHeight)
    }
    
    //MARK: - Target func
    @objc
    func goBack() {
        dismiss(animated: true)
    }
    
    //MARK: - Display
    func displayAlarm(_ alarm: AlarmResponse?) {
        guard let alarm else { return }
        avatarIcon.imageView.image = UIImage(named: alarm.user.iconName)
        creatorName.text = alarm.user.name
        tagName.text = alarm.category
        tagName.backgroundColor = UIColor(hex: alarm.categoryHexColor)
        date.text = alarm.date
        time.text = alarm.time
        descriptionLabel.text = alarm.description
        commentLabel.text = alarm.comment
    }
    
}
