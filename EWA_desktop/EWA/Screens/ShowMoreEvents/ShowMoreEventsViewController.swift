import UIKit

final class ShowMoreEventsViewController: UIViewController {
    
    typealias Model =  ShowMoreEventsModel
    
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
        
        static let dateFontSize: CGFloat = 25
        static let dateTop: CGFloat = 10
        static let dateLeft: CGFloat = 10
        static let dateRight: CGFloat = 70
        static let dateHeight: CGFloat = 28
        static let dateCornerRadius: CGFloat = 11
        static let dateTextColor: UIColor = .white
        
        static let placeFontSize: CGFloat = 21
        static let placeTop: CGFloat = 5
        static let placeLeft: CGFloat = 10
        static let placeRight: CGFloat = 70
        static let placeHeight: CGFloat = 28
        static let placeCornerRadius: CGFloat = 11
        
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
    
    var interactor :  ShowMoreEventsBusinessLogic
    
    var backView: UIView = UIView()
    let customBackButton = UIButton(type: .system)
    
    var eventId: String?
    
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
    
    private let namingLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: Constants.yanoneKaffeesatzBold, size: Constants.namingFontSize)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    var dateAndTime : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: Constants.yanoneKaffeesatzRegular, size: Constants.dateFontSize)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    var placeText : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: Constants.yanoneKaffeesatzRegular, size: Constants.placeFontSize)
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
        loadData()
        configureUI()
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //loadData()
    }
    
    //MARK: - Lyfecycle
    init(interactor:  ShowMoreEventsBusinessLogic, id: String) {
        self.interactor = interactor
        self.eventId = id
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    private func loadData() {
        //interactor.fetchEvent(id: eventId)
        avatarIcon.imageView.image = UIImage(named: "wolf")
        creatorName.text = "event.user.name"
        tagName.text = "event.category"
        namingLabel.text = "event.name"
        dateAndTime.text = "event.dateTime"
        placeText.text = "event.place"
        descriptionLabel.text = "event.description"
        commentLabel.text = "event.comment"
    }
    
    //MARK: - Configure UI
    private func configureUI() {
        configureView()
        configurebackButton()
        configureAvatar()
        configureProfileData()
        configureEventInformation()
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
        view.addSubview(namingLabel)
        
        creatorName.pinTop(to: avatarIcon.topAnchor, Constants.creatornameTop)
        creatorName.pinLeft(to: avatarIcon.trailingAnchor, Constants.creatornameLeft)
        creatorName.pinRight(to: backView.trailingAnchor, Constants.creatornameRight)
        creatorName.setHeight(Constants.creatornameHeight)
        
        tagName.pinTop(to: creatorName.bottomAnchor, Constants.categoryTop)
        tagName.pinLeft(to: creatorName.leadingAnchor)
        tagName.pinRight(to: backView.trailingAnchor, Constants.categoryRight)
        tagName.setHeight(Constants.categoryHeight)
        
        namingLabel.pinTop(to: tagName.bottomAnchor, Constants.namingTop)
        namingLabel.pinLeft(to: tagName.leadingAnchor)
        namingLabel.setHeight(Constants.namingHeight)
    }
    
    private func configureEventInformation() {
        view.addSubview(dateAndTime)
        view.addSubview(placeText)
        view.addSubview(descriptionText)
        view.addSubview(descriptionLabel)
        view.addSubview(commentText)
        view.addSubview(commentLabel)
        
        dateAndTime.pinTop(to: avatarIcon.bottomAnchor, Constants.dateTop)
        dateAndTime.pinLeft(to: avatarIcon.leadingAnchor, Constants.dateLeft)
        
        placeText.pinTop(to: dateAndTime.bottomAnchor, Constants.placeTop)
        placeText.pinLeft(to: dateAndTime.leadingAnchor)
        
        descriptionText.pinTop(to: placeText.bottomAnchor, Constants.descriptionTop)
        descriptionText.pinLeft(to: placeText.leadingAnchor)
        
        descriptionLabel.pinTop(to: descriptionText.bottomAnchor, Constants.descriptionLabelTop)
        descriptionLabel.pinHorizontal(to: backView, Constants.descriptionLabelLeft)
        descriptionLabel.setHeight(Constants.descriptionLabelHeight)
        
        commentText.pinTop(to: descriptionLabel.bottomAnchor, Constants.descriptionTop)
        commentText.pinLeft(to: placeText.leadingAnchor)
        
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
    func displayEvent(_ event: EventResponse) {
        avatarIcon.imageView.image = UIImage(named: event.user.iconName)
        creatorName.text = event.user.name
        namingLabel.text = event.name
        tagName.text = event.category
        dateAndTime.text = event.dateTime
        placeText.text = event.place
        descriptionLabel.text = event.description
        commentLabel.text = event.comment
    }
    
}
