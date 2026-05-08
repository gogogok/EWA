//
//  AdventureCollectionCardCell.swift
//  EWA
//
//  Created by Дарья Жданок on 16.04.26.
//

import UIKit

final class AdventureCollectionCardCell: UICollectionViewCell {
    
    static let reuseIdentifier = "AdventureCollectionCardCell"
    
    private enum Constants {
        static let cardViewTopBottom: CGFloat = 8
        static let cardViewLeftRight: CGFloat = 20
    }
    
    let cardView = AdventureCardView()
    
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
    
    func configure(with event: EventResponse, title: String) {
        let model = AdventureCardView.Model(id: event.id, title: event.name, description: event.description, category: event.category, dateText: event.date + " " + event.time, avatarIconName: event.user.iconName, buttonTitle: title)
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
