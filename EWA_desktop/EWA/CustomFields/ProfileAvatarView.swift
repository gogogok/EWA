import UIKit

final class ProfileAvatarView: UIView {
    
    private enum Constants {
        static let animationDuration: CGFloat = 0.15
        static let usingSpringWithDamping: CGFloat = 0.8
        static let initialSpringVelocity: CGFloat = 0.4
        static let scaleForTransform: CGFloat = 1.2
        static let selectedBorderAlpha: CGFloat = 0.5
        static let selectedBorderWidth: CGFloat = 2
        
        static let editSize: CGFloat = 26
        static let editBottom: CGFloat = 2
        static let editRight: CGFloat = 2
    }
    
    let imageView = UIImageView()
    let whiteView = UIView()
    let iconName: String
    var needEdition: Bool = false
    
    private let editButton = UIButton(type: .system)
    
    var onTap: ((ProfileAvatarView) -> Void)?
    var onEditTap: (() -> Void)?
    
    init(iconName: String, needEdition: Bool = false) {
        self.iconName = iconName
        self.needEdition = needEdition
        super.init(frame: .zero)
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
        whiteView.layer.cornerRadius = bounds.width / 2
        editButton.layer.cornerRadius = Constants.editSize / 2
    }
    
    func setSelected(_ isSelected: Bool) {
        UIView.animate(
            withDuration: Constants.animationDuration,
            delay: 0,
            usingSpringWithDamping: Constants.usingSpringWithDamping,
            initialSpringVelocity: Constants.initialSpringVelocity,
            options: [.allowUserInteraction]
        ) {
            self.transform = isSelected
                ? CGAffineTransform(scaleX: Constants.scaleForTransform, y: Constants.scaleForTransform)
                : .identity
            
            self.layer.borderWidth = isSelected ? Constants.selectedBorderWidth : 0
            self.layer.borderColor = isSelected
                ? UIColor.white.withAlphaComponent(Constants.selectedBorderAlpha).cgColor
                : UIColor.clear.cgColor
        }
    }
    
    private func configure() {
        clipsToBounds = true
        layer.borderWidth = 0
        isUserInteractionEnabled = true
        accessibilityIdentifier = iconName
        
        imageView.image = UIImage(named: iconName)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        addSubview(imageView)
        imageView.pin(to: self)
        
        if needEdition {
            whiteView.layer.borderWidth = 1.5
            whiteView.layer.borderColor = UIColor.gray.cgColor
            
            whiteView.contentMode = .scaleAspectFill
            whiteView.clipsToBounds = true
            whiteView.backgroundColor = .white
            whiteView.alpha = 0.6
            
            addSubview(whiteView)
            whiteView.pin(to: self)
            configureEditButton()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
    }
    
    private func configureEditButton() {
        addSubview(editButton)
        editButton.pinCenter(to: self)
        
        editButton.backgroundColor = UIColor.white.withAlphaComponent(0)
        editButton.layer.borderColor = UIColor.black.withAlphaComponent(0.15).cgColor
        
        let image = UIImage(named: "edit-text")
        editButton.setImage(image, for: .normal)
        editButton.tintColor = .black
        editButton.imageView?.contentMode = .scaleAspectFit
        editButton.clipsToBounds = true
        editButton.setWidth(40)
        
        editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
    }
    
    @objc
    private func handleTap() {
        onTap?(self)
    }
    
    @objc
    private func editTapped() {
        onEditTap?()
    }
}
