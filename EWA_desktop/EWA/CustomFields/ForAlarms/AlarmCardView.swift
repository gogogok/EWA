//
//  AlarmCardView.swift
//  EWA
//
//  Created by Дарья Жданок on 21.04.26.
//

import UIKit

final class AlarmCardView: UIView {
    
    struct Model {
        let id: String
        let description: String
        let category: String
        let categoryHexColor: String
        let dateText: String
        let avatarIconName: String
        let buttonTitle: String
        let count: Int
    }
    
    private enum Constants {
        static let defaultAvatarIconName: String = "wolf"
        
        static let cornerRadius: CGFloat = 22
        static let borderWidth: CGFloat = 2
        
        static let contentInset: CGFloat = 5
        static let horizontalSpacing: CGFloat = 5
        
        static let leftColumnWidth: CGFloat = 75
        static let rightColumnWidth: CGFloat = 75
        
        static let avatarTop: CGFloat = 0
        static let avatarSize: CGFloat = 65
        
        static let categoryTop: CGFloat = 4
        static let categoryLeftRight: CGFloat = 2
        static let categoryHeight: CGFloat = 20
        static let categoryWidth: CGFloat = 85
        static let categoryCornerRadius: CGFloat = 11
        static let categoryHorizontalInset: CGFloat = 5
        static let categoryVerticalInset: CGFloat = 2
        
        static let titleTop: CGFloat = 2
        static let titleLeft: CGFloat = 0
        static let titleRight: CGFloat = 8
        
        static let descriptionTop: CGFloat = 7
        static let descriptionMinHeight: CGFloat = 45
        static let descriptionCornerRadius: CGFloat = 10
        static let descriptionHorizontalInset: CGFloat = 5
        static let descriptionVerticalInset: CGFloat = 3
        
        static let rightColumnTop: CGFloat = 4
        static let dateTop: CGFloat = 30
        static let buttonTop: CGFloat = 10
        static let buttonHeight: CGFloat = 20
        static let buttonCornerRadius: CGFloat = 6
        static let buttonHorizontalInset: CGFloat = 4
        static let buttonBorderWidth: CGFloat = 0.5
        
        static let titleFontSize: CGFloat = 24
        static let descriptionFontSize: CGFloat = 12
        static let categoryFontSize: CGFloat = 12
        static let dateFontSize: CGFloat = 13
        static let buttonFontSize: CGFloat = 12
        
        static let titleMinimumScaleFactor: CGFloat = 0.75
        
        static let tinosRegular : String = "Tinos-Regular"
        static let tinosBold : String = "Tinos-Bold"
        
        static let cardBackgroundColor = UIColor(red: 0.29, green: 0.67, blue: 0.53, alpha: 1)
        static let descriptionBackgroundColor = UIColor(red: 0.92, green: 0.89, blue: 0.96, alpha: 1)
        static let buttonBackgroundColor = UIColor(red: 0.83, green: 0.73, blue: 0.97, alpha: 1)
        static let primaryTextColor: UIColor = .black
        static let categoryTextColor: UIColor = .white
        static let categoryBackgroundColor: UIColor = .black
        static let borderColor: CGColor = UIColor.black.cgColor
    }
    
    //MARK: - Callbacks
    var onJoinTap: (() -> Void)?
    var onCardTap: (() -> Void)?
    var onEditTap: (() -> Void)?
    
    private let avatarView = ProfileAvatarView(iconName: Constants.defaultAvatarIconName)
    
    private let categoryContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.categoryBackgroundColor
        view.layer.cornerRadius = Constants.categoryCornerRadius
        view.clipsToBounds = true
        return view
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.categoryTextColor
        label.textAlignment = .center
        label.font = UIFont(name: Constants.tinosBold, size: Constants.categoryFontSize)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.clipsToBounds = true
        label.layer.masksToBounds = true
        label.layer.cornerRadius = Constants.categoryCornerRadius
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    private let descriptionContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.descriptionBackgroundColor
        view.layer.cornerRadius = Constants.descriptionCornerRadius
        view.clipsToBounds = true
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont(name: Constants.tinosBold, size: Constants.descriptionFontSize)
        label.textAlignment = .left
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.primaryTextColor
        label.numberOfLines = 2
        label.font = UIFont(name: Constants.tinosBold, size: Constants.dateFontSize)
        label.textColor = .white
        return label
    }()
    
    private let countLabel: UILabel = {
        let badge = UILabel()
        badge.textAlignment = .center
        badge.textColor = .black
        badge.font = UIFont(name: "Tinos-Bold", size: 14)

        badge.backgroundColor = UIColor(hex: "#F8A7AD")
        badge.layer.cornerRadius = 10
        badge.layer.borderWidth = 1
        badge.layer.borderColor = UIColor.black.cgColor
        badge.layer.masksToBounds = true

        badge.setHeight(20)
        return badge
    }()
    
    private let joinButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(Constants.primaryTextColor, for: .normal)
        button.backgroundColor = Constants.buttonBackgroundColor
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.layer.borderWidth = Constants.buttonBorderWidth
        button.layer.borderColor = Constants.borderColor
        button.titleLabel?.font = UIFont(name: Constants.tinosBold, size: Constants.buttonFontSize)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "pencil")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        button.layer.cornerRadius = 14
        button.isHidden = true
        return button
    }()
    
    private var currentModel: Model?
    
    var isEditingMode: Bool = false {
        didSet {
            editButton.isHidden = !isEditingMode
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: Model, _ needNumb: Bool = false) {
        currentModel = model
        descriptionLabel.text = model.description
        categoryLabel.text = model.category
        categoryLabel.backgroundColor = UIColor(hex: model.categoryHexColor)
        setTitle(model.dateText, dateLabel)
        joinButton.setTitle(model.buttonTitle, for: .normal)
        if needNumb {
            countLabel.isHidden = false
            countLabel.text = "\(model.count)/3"
        } else {
            countLabel.isHidden = true
        }
        
        updateAvatar(iconName: model.avatarIconName)
    }
    
    private func configure() {
        backgroundColor = Constants.cardBackgroundColor
        layer.cornerRadius = Constants.cornerRadius
        layer.borderWidth = Constants.borderWidth
        layer.borderColor = Constants.borderColor
        clipsToBounds = true
        
        configureLayout()
        configureEditButton()
        configureActions()
    }
    
    private func configureLayout() {
        let leftColumn = UIView()
        let centerColumn = UIView()
        let rightColumn = UIView()
        
        addSubview(leftColumn)
        addSubview(centerColumn)
        addSubview(rightColumn)
        
        leftColumn.pinVertical(to: self, Constants.contentInset)
        leftColumn.pinLeft(to: leadingAnchor, Constants.contentInset)
        leftColumn.setWidth(Constants.leftColumnWidth)
        
        rightColumn.pinVertical(to: self, Constants.contentInset)
        rightColumn.pinRight(to: trailingAnchor, Constants.contentInset)
        rightColumn.setWidth(Constants.rightColumnWidth)
        
        centerColumn.pinVertical(to: self, Constants.contentInset)
        centerColumn.pinLeft(to: leftColumn.trailingAnchor, Constants.horizontalSpacing)
        centerColumn.pinRight(to: rightColumn.leadingAnchor, Constants.horizontalSpacing)
        
        configureLeftColumn(in: leftColumn)
        configureCenterColumn(in: centerColumn)
        configureRightColumn(in: rightColumn)
    }
    
    private func configureLeftColumn(in container: UIView) {
        container.addSubview(avatarView)
        
        avatarView.pinCenterX(to: container)
        avatarView.pinCenterY(to: container)
        avatarView.setWidth(Constants.avatarSize)
        avatarView.setHeight(Constants.avatarSize)
    }
    
    private func configureCenterColumn(in container: UIView) {
        
        container.addSubview(categoryLabel)
        container.addSubview(descriptionContainer)
        container.addSubview(dateLabel)
        
        categoryLabel.pinLeft(to: container)
        categoryLabel.pinTop(to: container, Constants.categoryTop)
        categoryLabel.setWidth(Constants.categoryWidth)
        
        descriptionContainer.addSubview(descriptionLabel)
        
        descriptionContainer.pinTop(to: categoryLabel.bottomAnchor, Constants.descriptionTop)
        descriptionContainer.pinHorizontal(to: container)
        descriptionContainer.setHeight(Constants.descriptionMinHeight)
        
        descriptionLabel.pinHorizontal(to: descriptionContainer, Constants.descriptionHorizontalInset)
        descriptionLabel.pinVertical(to: descriptionContainer)
        
        dateLabel.pinCenterY(to: categoryLabel)
        dateLabel.pinRight(to: container.trailingAnchor, 10)
    }
    
    private func configureRightColumn(in container: UIView) {
        container.addSubview(joinButton)
        container.addSubview(countLabel)
        
        joinButton.pinHorizontal(to: container, Constants.buttonHorizontalInset)
        joinButton.pinTop(to: container, 35)
        joinButton.pinBottom(to: container, 10)
        
        countLabel.pinBottom(to: joinButton.topAnchor, 5)
        countLabel.pinHorizontal(to: joinButton, 10)
    }
    
    private func configureEditButton() {
        addSubview(editButton)
        
        editButton.pinTop(to: topAnchor, 8)
        editButton.pinRight(to: trailingAnchor, 8)
        editButton.setWidth(28)
        editButton.setHeight(28)
    }
    
    private func configureActions() {
        joinButton.addTarget(self, action: #selector(joinTapped), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }
    
    private func updateAvatar(iconName: String) {
        avatarView.imageView.image = UIImage(named: iconName)
    }
    
    func setTitle(_ text: String, _ label: UILabel) {
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
        label.layer.shadowRadius = 2
        label.layer.shadowOpacity = 1
        label.text = text
    }
    
    @objc
    private func joinTapped() {
        onJoinTap?()
    }
    
    @objc
    private func cardTapped() {
        onCardTap?()
    }
    
    @objc
    private func editTapped() {
        onEditTap?()
    }
}
