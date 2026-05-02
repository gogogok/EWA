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
    
    let cardView = AlarmCardView()
    
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
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onJoinTap = nil
        onCardTap = nil
    }
    
    func configure(with alarm: AlarmResponse, title: String) {
        let model = AlarmCardView.Model(id: alarm.id, description: alarm.description, category: alarm.category, categoryHexColor: alarm.categoryHexColor, dateText: alarm.date + " " + alarm.time, avatarIconName: alarm.user.iconName, buttonTitle: title)
        cardView.configure(with: model)
    }
    
    private func configureUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(cardView)
        
        cardView.pinVertical(to: contentView, Constants.cardViewTopBottom)
        cardView.pinHorizontal(to: contentView, Constants.cardViewLeftRight)
    }
}
