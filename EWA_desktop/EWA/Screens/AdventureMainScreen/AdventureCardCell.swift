//
//  AdventureCardCell.swift
//  EWA
//
//  Created by Дарья Жданок on 8.04.26.
//

import UIKit

final class AdventureCardCell: UITableViewCell {
    
    static let reuseIdentifier = "AdventureCardCell"
    
    //MARK: - Constants
    private enum Constants {
        static let cardViewTopBottom : CGFloat = 8
        static let cardViewLeftRight : CGFloat = 20
    }
    
    private let cardView = AdventureCardView()
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: AdventureCardView.Model) {
        cardView.configure(with: model)
    }
    
    private func configureUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(cardView)
        
        cardView.pinVertical(to: contentView, Constants.cardViewTopBottom)
        cardView.pinHorizontal(to: contentView, Constants.cardViewLeftRight)
       
    }
}
