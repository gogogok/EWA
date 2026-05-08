//
//  AlarmCollectionCardCell.swift
//  EWA
//
//  Created by Дарья Жданок on 24.04.26.
//


import UIKit

final class AlarmCollectionCardCell: UICollectionViewCell {
    
    static let reuseIdentifier = "AlarmCollectionCardCell"
    
    private enum Constants {
        static let cardViewTopBottom: CGFloat = 8
        static let cardViewLeftRight: CGFloat = 20
    }
    
    private let deleteBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#F8A7AD")
        view.layer.cornerRadius = 22
        view.isHidden = true
        return view
    }()

    private let deleteLabel: UILabel = {
        let label = UILabel()
        label.text = "Отказаться"
        label.textColor = .black
        label.font = UIFont(name: "Tinos-Bold", size: 16)
        label.textAlignment = .right
        return label
    }()
    
    
    let cardView = AlarmCardView()
    
    var onSwipeLeft: (() -> Void)?
    
    var onJoinTap: (() -> Void)? {
        didSet {
            cardView.onJoinTap = onJoinTap
        }
    }
    
    var onCardTap: (() -> Void)? {
        didSet {
            cardView.onCardTap = onCardTap
        }
    }
    
    var onEditTap: (() -> Void)? {
        didSet {
            cardView.onEditTap = onEditTap
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipe.direction = .left
        contentView.addGestureRecognizer(swipe)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onSwipeLeft = nil
        onJoinTap = nil
        onCardTap = nil
        onEditTap = nil
    }
    
    func configure(with alarm: AlarmResponse, title: String) {
        let model = AlarmCardView.Model(id: alarm.id, description: alarm.description, category: alarm.category, categoryHexColor: alarm.categoryHexColor, dateText: alarm.date + " " + alarm.time, avatarIconName: alarm.user.iconName, buttonTitle: title, count: alarm.countPart)
        cardView.configure(with: model)
    }
    
    private func configureUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(cardView)
        
        cardView.pinVertical(to: contentView, Constants.cardViewTopBottom)
        cardView.pinHorizontal(to: contentView, Constants.cardViewLeftRight)
        
        contentView.insertSubview(deleteBackgroundView, at: 0)
        deleteBackgroundView.addSubview(deleteLabel)

        deleteBackgroundView.pinHorizontal(to: contentView, 20)
        deleteBackgroundView.pinVertical(to: contentView)

        deleteLabel.pinRight(to: deleteBackgroundView.trailingAnchor, 20)
        deleteLabel.pinCenterY(to: deleteBackgroundView)

        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipe.direction = .left
        contentView.addGestureRecognizer(swipe)
    }
    
    @objc
    private func handleSwipeLeft() {
        deleteBackgroundView.isHidden = false
        
        UIView.animate(withDuration: 0.25) {
            self.cardView.transform = CGAffineTransform(translationX: -110, y: 0)
        } completion: { _ in
            UIView.animate(withDuration: 0.15, delay: 0.4) {
                self.cardView.transform = .identity
            } completion: { _ in
                self.deleteBackgroundView.isHidden = true
                self.onSwipeLeft?()
            }
        }
    }
}
