import UIKit

final class ParticipantCell: UICollectionViewCell {
    
    static let reuseId = "ParticipantCell"
    
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.backgroundColor = .white.withAlphaComponent(0.75)
        contentView.layer.cornerRadius = 16
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 25
        avatarImageView.backgroundColor = UIColor(hex: "#D0B9FF")
        
        nameLabel.font = UIFont(name: "YanoneKaffeesatz-ExtraLight_Regular", size: 20)
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 1
        
        avatarImageView.pinLeft(to: contentView.leadingAnchor, 14)
        avatarImageView.pinCenterY(to: contentView)
        avatarImageView.setWidth(50)
        avatarImageView.setHeight(50)
        
        nameLabel.pinLeft(to: avatarImageView.trailingAnchor, 12)
        nameLabel.pinRight(to: contentView.trailingAnchor, 14)
        nameLabel.pinCenterY(to: contentView)
    }
    
    func configure(participant: StudyRoomParticipant) {

        nameLabel.text = participant.username

        if let iconName = participant.iconName,
           let image = UIImage(named: iconName) {
            avatarImageView.image = image
        } else {

            avatarImageView.image = UIImage(systemName: "person.fill")
            avatarImageView.tintColor = .white
        }
    }
    
    func configureWithUser(user: UserResponse) {

        nameLabel.text = user.name

        let iconName = user.iconName
        let image = UIImage(named: iconName)
        avatarImageView.image = UIImage(named: iconName)
    }
}
