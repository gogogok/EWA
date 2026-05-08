//
//  ChatMessageCell.swift
//  EWA
//
//  Created by Дарья Жданок on 6.05.26.
//

import UIKit

final class ChatMessageCell: UITableViewCell {

    static let reuseId = "ChatMessageCell"

    private let bubbleView = UIView()
    private let nameLabel = UILabel()
    private let messageLabel = UILabel()

    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(bubbleView)
        bubbleView.addSubview(nameLabel)
        bubbleView.addSubview(messageLabel)

        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        bubbleView.layer.cornerRadius = 18
        bubbleView.clipsToBounds = true

        nameLabel.font = .boldSystemFont(ofSize: 12)
        nameLabel.textColor = .darkGray

        messageLabel.font = .systemFont(ofSize: 15)
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0

        leadingConstraint = bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
        trailingConstraint = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)

        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            bubbleView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.72),

            nameLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12),

            messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -10)
        ])
    }

    func configure(with message: ChatMessage, isMine: Bool) {
        nameLabel.text = isMine ? "Вы" : message.username
        messageLabel.text = message.text

        leadingConstraint.isActive = !isMine
        trailingConstraint.isActive = isMine

        bubbleView.backgroundColor = isMine
            ? UIColor(red: 0.78, green: 0.69, blue: 1.0, alpha: 1)
            : UIColor.white

        nameLabel.textAlignment = isMine ? .right : .left
        messageLabel.textAlignment = isMine ? .right : .left
    }
}
