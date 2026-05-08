//
//  SearchInputView.swift
//  EWA
//
//  Created by Дарья Жданок on 5.04.26.
//

import UIKit

final class SearchInputView: UIView {
    
    // MARK: - Constants
    private enum Constants {
        static let cornerRadius: CGFloat = 15
        static let borderWidth: CGFloat = 2
        
        static let horizontalInset: CGFloat = 16
        static let iconTop: CGFloat = 14
        static let iconSize: CGFloat = 34
        static let iconTrailingToTextField: CGFloat = 14
        
        static let textFieldTopBottomInset: CGFloat = 12
        static let textFieldTrailing: CGFloat = 16
        
        static let textFieldCornerRadius: CGFloat = 10
        static let textFieldInnerLeftInset: CGFloat = 16
        
        static let fontSize: CGFloat = 22
    }
    
    // MARK: - Public
    let textField = PaddedTextField()
    let scroll = UIScrollView()
    
    var text: String {
        get { textField.text ?? "" }
        set { textField.text = newValue }
    }
    
    // MARK: - Private
    private let iconImageView = UIImageView()
    private let innerBackgroundView = UIView()
    
    // MARK: - Init
    init(
        placeholder: String
    ) {
        super.init(frame: .zero)
        configure(placeholder: placeholder)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func configure(placeholder: String) {
        backgroundColor = UIColor(hex: "#9EDCC8")
        layer.cornerRadius = Constants.cornerRadius
        layer.borderWidth = Constants.borderWidth
        layer.borderColor = UIColor.black.cgColor
        clipsToBounds = true
        
        configureIcon()
        configureInnerBackground()
        configureTextField(placeholder: placeholder)
    }
    
    private func configureIcon() {
        addSubview(iconImageView)
        
        iconImageView.image = UIImage(systemName: "magnifyingglass")
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .black
        
        iconImageView.pinTop(to: topAnchor, Constants.iconTop)
        iconImageView.pinLeft(to: leadingAnchor, Constants.iconTrailingToTextField)
        iconImageView.setHeight(Constants.iconSize)
        iconImageView.setWidth(Constants.iconSize)
    }
    
    private func configureInnerBackground() {
        addSubview(innerBackgroundView)
        
        innerBackgroundView.backgroundColor = UIColor(hex: "#FFF1FE")
        innerBackgroundView.layer.cornerRadius = Constants.textFieldCornerRadius
        innerBackgroundView.clipsToBounds = true
        
        innerBackgroundView.pinTop(to: topAnchor, Constants.textFieldTopBottomInset)
        innerBackgroundView.pinBottom(to: bottomAnchor, Constants.textFieldTopBottomInset)
        innerBackgroundView.pinLeft(to: iconImageView.trailingAnchor, Constants.iconTrailingToTextField)
        innerBackgroundView.pinRight(to: trailingAnchor, Constants.textFieldTrailing)
    }
    
    private func configureTextField(placeholder: String) {
        innerBackgroundView.addSubview(textField)
        
        textField.backgroundColor = .clear
        textField.textColor = .black
        textField.tintColor = .black
        textField.borderStyle = .none
        textField.font = UIFont(name: "YanoneKaffeesatz-ExtraLight_Bold", size: Constants.fontSize)
        
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor.gray
            ]
        )
        
        textField.pinTop(to: innerBackgroundView.topAnchor)
        textField.pinBottom(to: innerBackgroundView.bottomAnchor)
        textField.pinHorizontal(to: innerBackgroundView, Constants.textFieldInnerLeftInset)
    }
}
