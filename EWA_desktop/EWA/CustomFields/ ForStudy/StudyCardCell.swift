//
//  AlarmCardCell.swift
//  EWA
//
//  Created by Дарья Жданок on 21.04.26.
//

import UIKit

final class StudyCardCell: UITableViewCell {
    
    static let reuseIdentifier = "StudyCardCell"
    
    //MARK: - Constants
    private enum Constants {
        static let cardViewTopBottom : CGFloat = 8
        static let cardViewLeftRight : CGFloat = 20
    }
    
    private let cardView = StudyCardView()
    
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
    
    func configure(with model: AlarmCardView.Model, _ needNumb: Bool = false) {
        
        cardView.configure(with: model, needNumb)
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
